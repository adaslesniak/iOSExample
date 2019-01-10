// Typealiases.swift [SwiftSugar] created by: Adas Lesniak on: 11/12/2018
import Foundation


public enum Exception : Error { case error(String) }

public typealias Action = () -> Void
public typealias BoolAction = (Bool) -> Void

