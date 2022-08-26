//
//  NavigationSideBarView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct NavigationSideBarView: View {
    @EnvironmentObject var navData: NavData
    let size = 26.0
    let textStyle = Font.TextStyle.body
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    // Collapse Button
                    HStack {
                        Image(systemName: "sidebar.leading")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.1)
                    .padding(.leading)
                    
                    // Title
                    HStack {
                        Text("Navigation")
                            .foregroundColor(.white)
                            .font(Font.largeTitle.weight(.bold))
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.1)
                    .padding(.leading)
                    
                    // Navigation Items
                    VStack (spacing: 10) {
                        ForEach(navData.navigationItems) { navItem in
                            Button {
                                navData.navigationSelection = navItem.name
                            } label: {
                                HStack {
                                    Image(systemName: navItem.image)
                                        .padding(.leading)
                                        .scaledFrame(
                                            width: size,
                                            height: size,
                                            relativeTo: textStyle)
                                    
                                    Text("\(navItem.name)")
                                        .padding(.leading)
                                        .padding(.vertical, 10)
                                    Spacer()
                                }
                                .padding(.leading)
                                .background(Color.gray.opacity(navData.navigationSelection == navItem.name ? 0.15 : 0.0))
                            }
                        }
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    //.frame(height: geometry.size.height * 0.8)
                    
                    Spacer()
                    VStack {
                        Button {
                            navData.navigationSelection = "Settings"
                        } label: {
                            HStack {
                                Image(systemName: "gearshape.2.fill")
                                    .padding(.leading)
                                    .scaledFrame(
                                        width: size,
                                        height: size,
                                        relativeTo: textStyle)
                                
                                Text("Settings")
                                    .padding(.leading)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                            .padding(.leading)
                            .foregroundColor(.white)
                            .background(Color.gray.opacity(navData.navigationSelection == "Settings" ? 0.15 : 0.0))
                        }
                    }
                    .font(.title)
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                        .frame(height: geometry.size.height * 0.05)
                }
            }
        }
        .background(Color("DarkGray"))
    }
}


struct ToggleStates {
    var oneIsOn: Bool = false
    var twoIsOn: Bool = true
}

struct NavigationSideBarViewReviewLater: View {
    @State private var toggleStates = ToggleStates()
    @State private var topExpanded: Bool = true
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                // Navigation Items
                Menu {
                    Button {

                    } label: {
                        Text("Linear")
                        Image(systemName: "arrow.down.right.circle")
                    }
                    Button {
                    } label: {
                        Text("Radial")
                        Image(systemName: "arrow.up.and.down.circle")
                    }
                } label: {
                     Text("Style")
                     Image(systemName: "tag.circle")
                }
                GroupBox {
                    DisclosureGroup("Menu 1") {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                }
                DisclosureGroup("Items", isExpanded: $topExpanded) {
                        Text("Home")
                        Toggle("Toggle 1", isOn: $toggleStates.oneIsOn)
                        Toggle("Toggle 2", isOn: $toggleStates.twoIsOn)
                   }
                .frame(width: .infinity, alignment: .leading)
                Form {
                    DisclosureGroup(isExpanded: $topExpanded) {
                        HStack {
                            Text("This is some text")
                            Spacer()
                        }
                                } label: {
                                    Text("A really long disclosure group title that is being center aligned.")
                                        .multilineTextAlignment(.leading)
                                }
                }
                
            }
        }
    }
}

struct NavigationSideBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSideBarView()
            .environmentObject(NavData())
    }
}

struct ScaledFrame<Content>: View where Content: View {
    @ScaledMetric private var width: Double
    @ScaledMetric private var height: Double
    private var alignment: Alignment
    private var content: () -> Content
    
    init(
        width: ScaledMetric<Double>? = nil,
        height: ScaledMetric<Double>? = nil,
        alignment: Alignment = .center,
        content: @escaping () -> Content
    ) {
        _width = width ?? ScaledMetric(wrappedValue: -1)
        _height = height ?? ScaledMetric(wrappedValue: -1)
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        content().frame(
            width: width > 0 ? width : nil,
            height: height > 0 ? height : nil,
            alignment: alignment)
    }
}

// For convenience :)
extension View {
    func scaledFrame(
        width: Double?,
        height: Double?,
        relativeTo textStyle: Font.TextStyle,
        alignment: Alignment = .center
    ) -> some View {
        ScaledFrame(
            width: width.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            height: height.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) }) {
                self
            }
    }
}
