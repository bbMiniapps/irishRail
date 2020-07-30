//
//  MenuSwiftUIView.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import SwiftUI

struct MenuSwiftUIView: View {
    
    @ObservedObject var scheduleMenu: ScheduleMenu
    let changeDirectionAction: () -> Void
    let goAction: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text(scheduleMenu.calendar?.dayDescription ?? "")
                        .foregroundColor(Color.gray)
                        .frame(width: 60)
                    Text(scheduleMenu.calendar?.day ?? "")
                        .foregroundColor(.black)
                        .font(Font.system(.largeTitle)) //Font.system(size: 30)
                        .frame(width: 60)
                    Text(scheduleMenu.calendar?.month ?? "")
                        .foregroundColor(Color.gray)
                        .frame(width: 60)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                
                HStack {
                    Text(scheduleMenu.destination?.startPointDesc ?? "")
                        .font(Font.system(size: 24))
                        .padding(.leading, 15)
                    
                    Button(action: {
                        guard self.scheduleMenu.isEnable else {
                            return
                        }
                        
                        withAnimation(.default) {
                            let startPointDesc = self.scheduleMenu.destination?.endPointDesc ?? ""
                            let endPointDesc = self.scheduleMenu.destination?.startPointDesc ?? ""
                            let direction = self.scheduleMenu.destination?.direction ?? TrainDirection.north
                            let nDirection: TrainDirection = direction == .north ? .south : .north
                            self.scheduleMenu.destination = DestinationData(startPointDesc: startPointDesc,
                                                                            endPointDesc: endPointDesc,
                                                                            direction: nDirection)
                            
                            self.changeDirectionAction()
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(self.scheduleMenu.isEnable ? Color("CustomBlue") : .gray)
                            .padding()
                    }
                    
                    Text(scheduleMenu.destination?.endPointDesc ?? "")
                        .font(Font.system(size: 24))
                    
                    Spacer(minLength: 10)
                    
                    Button(action: {
                        guard self.scheduleMenu.isEnable else {
                            return
                        }
                        
                        self.goAction()
                    }) {
                        Text("Go")
                            .foregroundColor(.white)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .padding(.top, 6)
                            .padding(.bottom, 6)
                            .background(self.scheduleMenu.isEnable ? Color("CustomBlue") : .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(.trailing, 15)
                    }
                }
            }
            .animation(.default)
            
        }
    }
    
}

//struct MenuSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuSwiftUIView()
//    }
//}

final class ScheduleMenu: ObservableObject {
    
    @Published var calendar: CalendarData?
    @Published var destination: DestinationData?
    @Published var isEnable = true
    
}

struct CalendarData {
    
    let dayDescription: String
    let day: String
    let month: String
    
}

struct DestinationData {
    
    let startPointDesc: String
    let endPointDesc: String
    let direction: TrainDirection
    
}
