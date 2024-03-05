import ComposableArchitecture
import FlowStacks
import Foundation
import SwiftUI

public extension TCARouter
  where
  ID == Int,
  CoordinatorAction: IndexedRouterAction,
  CoordinatorAction.Screen == Screen,
  CoordinatorAction.ScreenAction == ScreenAction,
  CoordinatorState: IndexedRouterState,
  CoordinatorState.Screen == Screen
{
  /// Convenience initializer for managing screens in an `Array` identified by index, where
  /// State and Action conform to the `IdentifiedRouter...` protocols.
  init(
    _ store: Store<CoordinatorState, CoordinatorAction>,
    kp: @escaping (Int, Screen) -> KeyPath<CoordinatorState, Screen>,
    ckp: @escaping (Int, Screen) -> CaseKeyPath<CoordinatorAction, ScreenAction>,
    screenContent: @escaping (Store<Screen, ScreenAction>) -> ScreenContent
  ) {
    self.init(
      store: store,
      routes: { $0.routes },
      updateRoutes: CoordinatorAction.updateRoutes,
      action: CoordinatorAction.routeAction,
      screenContent: screenContent,
      kp: kp,
      ckp: ckp
    )
  }
}
