import ComposableArchitecture
import FlowStacks
import Foundation

/// A protocol standardizing naming conventions for state types that contain routes
/// within an `IdentifiedArray`.
public protocol IdentifiedRouterState {
  associatedtype Screen: Identifiable

  /// An identified array of routes representing a navigation/presentation stack.
  var routes: IdentifiedArrayOf<Route<Screen>> { get set }
}

public extension IdentifiedRouterState {
  subscript(stateFor id: Screen.ID, screen: Screen) -> Screen {
    return routes[id: id]?.screen ?? screen
  }
}
