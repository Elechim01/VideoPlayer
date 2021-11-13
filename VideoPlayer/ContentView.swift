//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Michele Manniello on 14/11/21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State var player = AVPlayer(url: URL(string: url)!)
    @State var isplaying = false
    @State var showControls = false
    @State var value : Float = 0
    var body: some View {
//        Player semplice
//        VStack{
//            player()
//                .frame(height: UIScreen.main.bounds.height / 2.3)
//            Spacer()
//        }
        
        VStack{
            ZStack{
                VideoPlayer(player1: $player)
                
                if self.showControls{
                    Controls(player: $player, isplaying: $isplaying, pannel: $showControls,value: self.$value)
                }
                
            }
           .frame(height: UIScreen.main.bounds.height / 3.5)
           .onTapGesture {
               self.showControls = true
           }
            GeometryReader{_ in
                VStack{
                    Text("Custom video Player")
                        .foregroundColor(.white)
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            self.player.play()
            self.isplaying = true
        }
        
        
    }
}
struct Controls: View {
    
    @Binding var player : AVPlayer
    @Binding var isplaying: Bool
    @Binding var pannel : Bool
    @Binding  var value : Float
    
    var body: some View{
        VStack{
            Spacer()
            
            HStack{
                Button(action: {
                    self.player.seek(to: CMTime(seconds: self.getSeconds() - 10, preferredTimescale: 1))
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    
                    if self.isplaying{
                        self.player.pause()
                        self.isplaying = false
                    }else{
                        self.player.play()
                        self.isplaying = true
                    }
                    
                }) {
                    Image(systemName: self.isplaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    self.player.seek(to: CMTime(seconds: self.getSeconds() + 10, preferredTimescale: 1))
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
            }
            Spacer()
            CustomProgressBar(value: self.$value,playerq: $player,isplaying: $isplaying)
        }
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all))
        .onTapGesture {
            self.pannel = false
        }
        .onAppear {
            self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { _ in
                self.value = getSliderValue()
                
                if self.value == 1.0{
                    self.isplaying = false
                }
            }
        }
    }
    
    func getSliderValue() -> Float {
        return  Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds)!)
    }
    func getSeconds() -> Double {
        return  Double(Double(self.value) * (self.player.currentItem?.duration.seconds)!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
