//
//  Player.swift
//  VideoPlayer
//
//  Created by Michele Manniello on 13/11/21.
//

import SwiftUI
import AVKit

let url = "http://e.pc.cd/Q1fotalK"

//"https://firebasestorage.googleapis.com/v0/b/testfirebase-d79fa.appspot.com/o/Supercar.1x01.Nuova.Identita.avi.mp4?alt=media&token=746607d5-900f-4a37-bfc1-b8c2ddd9c694"

struct player: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
       
        let player1 = AVPlayer(url: URL(string: url)!)
        controller.player = player1
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<player>) {
        
    }
}
// the white space for ur personalization content...

struct VideoPlayer : UIViewControllerRepresentable {
    
    @Binding var player1 : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController{
            let controller = AVPlayerViewController()
        controller.player = player1
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        
    }
}


struct CustomProgressBar: UIViewRepresentable {
    
    func makeCoordinator() -> CustomProgressBar.Coordinator {
        return CustomProgressBar.Coordinator(parent1: self)
    }
    
    @Binding var value : Float
    @Binding var playerq : AVPlayer
    @Binding var isplaying: Bool
    
    func makeUIView(context: Context) -> UISlider{
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .gray
        slider.thumbTintColor = .red
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.value = value
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
        return slider
    }
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = value
    }
    
    class Coordinator: NSObject {
        
        var parent : CustomProgressBar
        
        init(parent1: CustomProgressBar) {
            self.parent = parent1
        }
        
        @objc func changed(slider: UISlider){
            if slider.isTracking{
                parent.playerq.pause()
                
                let sec = Double(slider.value * Float((parent.playerq.currentItem?.duration.seconds)!))
                
                parent.playerq.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
            }else{
                let sec = Double(slider.value * Float((parent.playerq.currentItem?.duration.seconds)!))
                
                parent.playerq.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
                
                if parent.isplaying{
                    parent.playerq.play()
                }
            }
        }
    }
}

class Host: UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
