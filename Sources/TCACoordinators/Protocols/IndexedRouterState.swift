import FlowStacks
import Foundation

/// A protocol standardizing naming conventions for state types that contain routes
/// within an `IdentifiedArray`.
public protocol IndexedRouterState {
  associatedtype Screen

  /// An array of screens, identified by index, representing a navigation/presentation stack.
  var routes: [Route<Screen>] { get set }
  subscript(stateFor index: Int, screen: Screen) -> Screen { get }
}

public extension IndexedRouterState {
  subscript(stateFor index: Int, screen: Screen) -> Screen {
    return routes[safe: index]?.screen ?? screen
  }
}
