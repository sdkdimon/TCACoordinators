import ComposableArchitecture
import SwiftUI

@Reducer
struct Step1 {
  @ObservableState
  public struct State: Equatable {
     var firstName: String = ""
     var lastName: String = ""
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case nextButtonTapped
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
  }
}

struct Step1View: View {
  @Perception.Bindable var store: StoreOf<Step1>

  var body: some View {
    WithPerceptionTracking {
      Form {
//        TextField("First Name", text: viewStore.$firstName)
//        TextField("Last Name", text: viewStore.$lastName)

        Section {
          Button("Next") {
            store.send(.nextButtonTapped)
          }
        }
      }
      .navigationTitle("Step 1")
    }
  }
}
