import ComposableArchitecture
import SwiftUI

struct Step3View: View {
  @Perception.Bindable var store: StoreOf<Step3>
  
  @MainActor @ViewBuilder func buildLabelFor(occupation: String) -> some View {
    WithPerceptionTracking {
      HStack {
        Text(occupation)
        Spacer()
        if let selected = store.selectedOccupation, selected == occupation {
          Image(systemName: "checkmark")
        }
      }
    }
  }

  var body: some View {
    WithPerceptionTracking {
      Form {
        Section {
          if !store.occupations.isEmpty {
            ForEach(store.occupations, id: \.self) { occupation in
              Button {
                store.send(.selectOccupation(occupation))
              } label: {
                buildLabelFor(occupation: occupation)
                .buttonStyle(.plain)
              }
            }
            
          } else {
            ProgressView()
              .progressViewStyle(.automatic)
          }
        } header: {
          Text("Jobs")
        }

        Button("Next") {
          store.send(.nextButtonTapped)
        }
      }
      .onAppear {
        store.send(.getOccupations)
      }
      .navigationTitle("Step 3")
    }
  }
}

@Reducer
struct Step3 {
  @ObservableState
  struct State: Equatable {
    var selectedOccupation: String?
    var occupations: [String] = []
  }

  enum Action: Equatable {
    case getOccupations
    case receiveOccupations([String])
    case selectOccupation(String)
    case nextButtonTapped
  }

  let getOccupations: () async -> [String]

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .getOccupations:
        return .run { send in
          try await Task.sleep(nanoseconds: 3_000_000_000)
          await send(.receiveOccupations(getOccupations()))
        }

      case .receiveOccupations(let occupations):
        state.occupations = occupations
        return .none

      case .selectOccupation(let occupation):
        if state.occupations.contains(occupation) {
          state.selectedOccupation = state.selectedOccupation == occupation ? nil : occupation
        }

        return .none

      case .nextButtonTapped:
        return .none
      }
    }
  }
}
