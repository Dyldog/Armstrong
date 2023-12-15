//
//  File.swift
//  
//
//  Created by Dylan Elliott on 15/12/2023.
//

import SwiftUI

struct ExpandableStack<Header: View, Body: View>: View {
    
    var title: String
    @ViewBuilder var headerCollapsed: () -> Header
    @ViewBuilder var content: () -> Body
    @State var expanded: Bool = false
    @State var sheetPresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }, label: {
                    Image(systemName: "arrowtriangle.down.fill")
                        .rotationEffect(.degrees(expanded ? 0 : -90))
                })
                .simultaneousGesture(LongPressGesture().onEnded { _ in
                    sheetPresented = true
                })
                .foregroundStyle(.blue)
                
                Text(title).bold()
                Spacer()
                
                if !expanded {
                    headerCollapsed()
                }
            }
            
            if expanded {
                HStack {
                    Rectangle()
                        .foregroundStyle(.blue)
                        .frame(width: 4)
                        .cornerRadius(2)
                    
                    content()
                }
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
