import ComposableArchitecture

extension Route: ComposableArchitecture.ObservableState, Observation.Observable {
    public var _$id: ComposableArchitecture.ObservableStateID {
        switch self {
        case let .push(state):
            return ._$id(for: state)._$tag(0)
        case let .sheet(state, _, _):
            return ._$id(for: state)._$tag(1)
        case let .cover(state, _, _):
            return ._$id(for: state)._$tag(2)
        }
    }

    public mutating func _$willModify() {
        switch self {
        case var .push(state):
            ComposableArchitecture._$willModify(&state)
            self = .push(state)
        case .sheet(var state, let embedInNavigationView, let onDismiss):
            ComposableArchitecture._$willModify(&state)
            self = .sheet(state, embedInNavigationView: embedInNavigationView, onDismiss: onDismiss)
        case .cover(var state, let embedInNavigationView, let onDismiss):
            ComposableArchitecture._$willModify(&state)
            self = .sheet(state, embedInNavigationView: embedInNavigationView, onDismiss: onDismiss)
        }
    }
}
