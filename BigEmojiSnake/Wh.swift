import FortuneWheel
import SwiftUI

struct FortuneSwiftUI: View {
    
    var delegate: BonusViewController
    
    var lastIndex: Int
    
     var players = ["🐼10", "💩", "🐼1", "💩", "🐼5", "💩", "🐼5", "💩", "🐼20", "💩"]
    
    @State private var isInteractionDisabled = false
    @State private var isShowingTemporaryView = true
    @State private var isShowingAlert = false
    @State private var alertMessage = "You have got no cherries"
 
        var body: some View {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                if isShowingTemporaryView {
                    TemporaryView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isShowingTemporaryView = false
                            }
                        }
                } else {
                    
                    VStack {
                        HStack {
                            Spacer(minLength: 10)
                            Button(action: {
                                delegate.dismiss(animated: true)
                            }) {
                                Image("btn_back")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            Image("roll")
                                .resizable()
                                .scaledToFit()
                            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        }
                        FortuneWheel(
                            titles: players,
                            size: 320,
                            onSpinEnd: onSpinEnd,
                            getWheelItemIndex: getWheelItemIndex
                        ).font(.custom("GillSans-UltraBold", size: 26)).tint(.black)
                        .disabled(isInteractionDisabled)
                        HStack {
                            Image("swipe")
                                .resizable()
                                .scaledToFit()
                        }
                        Spacer()
                    }
                }
            }.alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Result"),
                    message: Text(alertMessage),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            delegate.dismiss(animated: true)
                        }
                    )
                )
            }
        }
    
    struct TemporaryView: View {
        var body: some View {
            VStack {
                Spacer()
                Image("spin")
                    .resizable()
                    .scaledToFit()
                                .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
    }

        private func onSpinEnd(index: Int) {
            isShowingAlert = true
            isInteractionDisabled = true
            let manager = ScoreManager.shared
            switch lastIndex {
            case 0:
                alertMessage = "You have got 10 points!"
                manager.addPoints(10)
            case 2:
                alertMessage = "You have got 1 point!"
                manager.addPoints(1)
            case 4:
                alertMessage = "You have got 5 points!"
                manager.addPoints(5)
            case 6:
                alertMessage = "You have got 5 points!"
                manager.addPoints(5)
            case 8:
                alertMessage = "You have got 20 points!"
                manager.addPoints(20)
            default:
                break
            }
        }

        private func getWheelItemIndex() -> Int {
            return lastIndex
        }
}

import UIKit

class BonusViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            showGame()
            
            func showGame() {
                let mainView = FortuneSwiftUI(delegate: self, lastIndex: Int.random(in: 0...9))
                let hostingController = UIHostingController(rootView: mainView)
                addChild(hostingController)
                view.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
            }
        }

}
