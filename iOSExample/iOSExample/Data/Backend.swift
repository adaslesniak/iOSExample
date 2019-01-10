// Backend.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019 


import Foundation

//Backend or in other words ServerApi - here comes all implementations of calls to server
//yes I know Apple would use Backend.shared... but we can skip repeating this "shared" thing everywhere
class Backend {
    
    public static func getExampleObjects(whenDone: @escaping ([ExampleObject]) -> Void) {
        let request = unauthorizedJsonRequest("http://dev.tapptic.com/test/json.php") //FIXME: that is not secure
        executeRequest(request, errorHandling: {
            print("ERROR when requesting get for exampleObjects")
        }) { data, response in
            guard let data = data else {
                throw Exception.error("no data, response: \(response.debugDescription)")
            }
            guard let answer = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else {
                throw Exception.error("couldn't read json object")
            }
            var details = [ExampleObject]()
            for detail in answer {
                if let deserialised = ExampleObject(serialised: detail) {
                    details.append(deserialised)
                    getTitle(for: deserialised) { _ in }
                } else {
                    print("ERROR: failed to deserialise detail: \(detail)")
                }
            }
            whenDone(details)
        }
    }
    
    //FIXME: that naming exampleObject of type ExampleObject is blasphemy... but there is no sense which I could use for naming - it's just an example
    static func getTitle(for exampleObject: ExampleObject, whenDone: @escaping (String?) -> Void) {
        let request = unauthorizedJsonRequest("http://dev.tapptic.com/test/json.php?name=\(exampleObject.text)")
        executeRequest(request, errorHandling: {
            print("ERROR when requesting title for object")
        }) { data, answer in
            guard let data = data else {
                throw Exception.error("no data in answer for getTitle")
            }
            print("got data: \(data)")
            guard let answer = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {
                throw Exception.error("couldn't read json title")
            }
            print("got answer: \(answer)")
            guard let title = answer.valueAtPath("text") as? String else {
                throw Exception.error("couldn't fine value for text key")
            }
            print("title is: \(title)")
            whenDone(title)
        }
    }
    
    
    //==============================================================
    //======== generic private stuff for dealing with REST =========
    private static func unauthorizedJsonRequest(_ endpoint: String) -> URLRequest {
        guard let api = URL(string: endpoint)  else {
            fatalError("ERROR: wrong string for making url request: \(endpoint)")
        }
        var request = URLRequest(url: api)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: request.addValue("", forHTTPHeaderField: "Authorization")
        return request
    }
    
    typealias AnswerProcessing = (Data?, URLResponse?) throws -> Void
    private static func executeRequest(_ theRequest: URLRequest, errorHandling: Action? = nil, _ answerProcessing: @escaping AnswerProcessing) {
        var isDone = false
        ExecuteInBackground(after: 90) {
            if !isDone {
                isDone = true
                print("Warning! request timed out: \(theRequest.url?.absoluteString ?? "nil")")
                errorHandling?()
            }
        }
        ExecuteInBackground {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let job = session.dataTask(with: theRequest) { data, response, error in
                do {
                    guard !isDone else {
                        print("Warning! answer took way too long, request already timed out")
                        return
                    }
                    guard error == nil else {
                        throw Exception.error("answer has an error: \(error!)")
                    }
                    try answerProcessing(data, response)
                    isDone = true
                } catch {
                    print("Warning! failed to executeRequest: [\(theRequest)]: \n\(error)")
                    errorHandling?()
                }
                isDone = true
            }
            job.resume()
        }
    }
}
