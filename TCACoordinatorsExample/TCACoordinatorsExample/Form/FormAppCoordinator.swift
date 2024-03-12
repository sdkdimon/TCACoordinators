import ComposableArchitecture
import SwiftUI
import TCACoordinators

extension Case where Value == FormAppCoordinator.Action {
  subscript(index index: Int) -> Case<FormScreen.Action> {
    Case<FormScreen.Action> { (value: FormScreen.Action)  in
      FormAppCoordinator.Action.routeAction(index, action: value)
    } extract: { (root: FormAppCoordinator.Action) in
      if case let .routeAction(_, action) = root { return action }
      return nil
    }
  }
}

@Reducer
struct FormAppCoordinator {
  @ObservableState
  struct State: IndexedRouterState, Equatable {
    static let initialState = Self(routes: [.root(.step1(.init()), embedInNavigationView: true)])
    
    var step1State = Step1.State()
    var step2State = Step2.State()
    var step3State = Step3.State()
    
    var finalScreenState: FinalScreen.State {
      return .init(firstName: step1State.firstName, lastName: step1State.lastName, dateOfBirth: step2State.dateOfBirth, job: step3State.selectedOccupation)
    }
    
    var routes: [Route<FormScreen.State>]
    
    mutating func clear() {
      step1State = .init()
      step2State = .init()
      step3State = .init()
    }
  }
  
  enum Action: IndexedRouterAction {
    case updateRoutes([Route<FormScreen.State>])
    case routeAction(Int, action: FormScreen.Action)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .routeAction(_, action: .step1(.nextButtonTapped)):
        state.routes.push(.step2(.init()))
        return .none
        
      case .routeAction(_, action: .step2(.nextButtonTapped)):
        state.routes.push(.step3(.init()))
        return .none
        
      case .routeAction(_, action: .step3(.nextButtonTapped)):
        state.routes.push(.finalScreen(state.finalScreenState))
        return .none
        
      case .routeAction(_, action: .finalScreen(.returnToName)):
        state.routes.goBackTo(id: .step1)
        return .none
        
      case .routeAction(_, action: .finalScreen(.returnToDateOfBirth)):
        state.routes.goBackTo(id: .step2)
        return .none
        
      case .routeAction(_, action: .finalScreen(.returnToJob)):
        state.routes.goBackTo(id: .step3)
        return .none
        
      case .routeAction(_, action: .finalScreen(.receiveAPIResponse)):
        state.routes.goBackToRoot()
        state.clear()
        return .none
        
      default:
        return .none
      }
    }.forEachRoute {
      FormScreen(environment: .test)
    }
  }
}

struct FormAppCoordinatorView: View {
  @Perception.Bindable var store: StoreOf<FormAppCoordinator>
  
  @MainActor @ViewBuilder func buildContentFor(screenStore: StoreOf<FormScreen>) -> some View {
    WithPerceptionTracking {
      switch screenStore.state {
      case .step1:
        if let store = screenStore.scope(state: \.step1, action: \.step1) {
          Step1View(store: store)
        }
      case .step2:
        if let store = screenStore.scope(state: \.step2, action: \.step2) {
          Step2View(store: store)
        }
      case .step3:
        if let store = screenStore.scope(state: \.step3, action: \.step3) {
          Step3View(store: store)
        }
      case .finalScreen:
        if let store = screenStore.scope(state: \.finalScreen, action: \.finalScreen) {
          FinalScreenView(store: store)
        }
      }
    }
  }
  
  var body: some View {
    WithPerceptionTracking {
      Router(
        $store.routes.sending(\.updateRoutes),
        buildView: { screen, index in
          buildContentFor(
            screenStore: store.scope(
              state: \FormAppCoordinator.State[stateFor: index, screen],
              action: \Case<FormAppCoordinator.Action>[index: index])
          )
        }
      )
    }
  }
}
