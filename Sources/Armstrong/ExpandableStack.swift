//
//  File.swift
//  
//
//  Created by Dylan Elliott on 15/12/2023.
//

import SwiftUI
import DylKit

struct ExpandableStack<Header: View, Body: View>: View {
    
    let scope: Scope
    var title: String
    @ViewBuilder var headerCollapsed: () -> Header
    @ViewBuilder var content: () -> Body
    @State var expanded: Bool = false
    @State var sheetPresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Spacer()
                    
                    HStack {
                        LongPressButton {
                            withAnimation {
                                expanded.toggle()
                            }
                        } longPressAction: {
                            sheetPresented = true
                        } label: {
                            Image(systemName: "arrowtriangle.down.fill")
                                .rotationEffect(.degrees(expanded ? 0 : -90))
                        }
                        .scope(scope)
                        
                        Text(title).bold().scope(scope)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                if !expanded {
                    headerCollapsed().scope(scope)
                }
            }
            
            if expanded {
                HStack {
                    Rectangle()
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(scope.color)
                        .frame(width: 4)
                        .cornerRadius(2)
                        .padding(.horizontal, 6)
                    
                    content()
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .sheet(isPresented: $sheetPresented, content: {
            NavigationView {
                ScrollView {
                    content()
                        .padding()
                }
                .navigationTitle(title)
            }
        })
    }
}
