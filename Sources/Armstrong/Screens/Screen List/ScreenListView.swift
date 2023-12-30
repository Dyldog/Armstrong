//
//  ScreenListView.swift
//  AppApp
//
//  Created by Dylan Elliott on 22/11/2023.
//

import SwiftUI
import DylKit
import WidgetKit

public class ScreenListViewModel: ObservableObject {
    public var screens: [Screen] {
        get {
            Screen.screens
        }
        set {
            objectWillChange.send()
            Screen.screens = newValue
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    var defaultScreens: [Screen] { AALibrary.shared.demoScreens }
    
    public init() { }
}

public struct ScreenListView: View {
    @ObservedObject var viewModel: ScreenListViewModel
    @State var selectedScreen: (Screen, Int?)?
    @State var showExport: Bool = false
    @State var exportScreen: Screen?
    
    public init(viewModel: ScreenListViewModel) {
        self.viewModel = viewModel
    }
    
    func onUpdate(_ screen: Screen, index: Int?) -> ((Screen) -> Void)? {
        if let index = index {
            return {
                viewModel.objectWillChange.send()
                viewModel.screens[index] = $0
            }
        } else {
            return { _ in }
        }
    }
    
    func screenView(_ screen: Screen, index: Int?) -> some View {
        Button {
            selectedScreen = (screen, index)
        } label: {
            Text(screen.name).font(.largeTitle)
        }
        .buttonStyle(.plain)
    }
    
    func exportButton(for screen: Screen) -> some View {
        Button {
            exportScreen = screen
            showExport = true
        } label: {
            Label("Favorite", systemImage: "square.and.arrow.up")
        }
        .tint(.yellow)
    }
    
    public var body: some View {
        List {
            if !viewModel.screens.isEmpty {
                Section("User") {
                    ForEach(viewModel.screens.enumeratedArray(), id: \.element.id) { (index, screen) in
                        screenView(screen, index: index)
                        .swipeActions {
                            Button {
                                UIPasteboard.general.copy(screen)
                            } label: {
                                Label("Copy", systemImage: "doc.on.clipboard")
                            }
                            .tint(.blue)
                            
                            exportButton(for: screen)
                
                            Button {
                                viewModel.screens.remove(atOffsets: [index])
                                viewModel.objectWillChange.send()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            
            Section("Defaults") {
                ForEach(viewModel.defaultScreens) { screen in
                        screenView(screen, index: nil)
                        .swipeActions {
                            exportButton(for: screen)
                        }
                }
            }
        }
        .fileExporter(
            isPresented: $showExport,
            document: exportScreen.map { ScreenDocument(screen: $0) },
            contentType: .screen,
            defaultFilename: exportScreen?.name,
            onCompletion: { _ in
                //
            })
        .navigationTitle("Screens")
        .navigationDestination(for: $selectedScreen, destination: { (screen, index) in
            ViewMakerView(viewModel: .init(
                scope: .init(),
                screen: screen,
                makeMode: false,
                onUpdate: onUpdate(screen, index: index))
            )
        })
        .toolbar {
            ToolbarItem(placement: .navigation) {
                SwiftUI.Button {
                    viewModel.screens.append(Screen(
                        id: .init(),
                        name: randomString(length: 5).uppercased(), 
                        initVariables: .makeDefault(),
                        initActions: .init(value: []),
                        subscreens: [],
                        content: .makeDefault()
                    ))
                    viewModel.objectWillChange.send()
                } label: {
                    Image(systemName: "plus.app.fill")
                }
            }
        }
    }
}

struct NavigationStackModifier<Item, Destination: View>: ViewModifier {
    let item: Binding<Item?>
    let destination: (Item) -> Destination

    func body(content: Content) -> some View {
        content.background(NavigationLink(isActive: item.mappedToBool()) {
            if let item = item.wrappedValue {
                destination(item)
            } else {
                EmptyView()
            }
        } label: {
            EmptyView()
        })
    }
}

public extension View {
    func navigationDestination<Item, Destination: View>(
        for binding: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        self.modifier(NavigationStackModifier(item: binding, destination: destination))
    }
}

public extension Binding where Value == Bool {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: {
                bindingOptional.wrappedValue != nil
            },
            set: { newValue in
                guard newValue == false else { return }

                /// We only handle `false` booleans to set our optional to `nil`
                /// as we can't handle `true` for restoring the previous value.
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    public func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        return Binding<Bool>(bindingOptional: self)
    }
}
