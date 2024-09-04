//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Lori Rothermel on 9/3/24.
//

import SwiftUI
import AVFAudio
import PhotosUI



struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    animateImage = false   // Will immediately shrink using .scaleEffect to 90% of size.
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true
                    }  // withAnimation
                }  // .onTapGesture
            
            
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }  // PhotosPicker
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    do {
                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                bipImage = Image(uiImage: uiImage)
                                print("bipImage converted")
                            }
                        }  // if let data
                    } catch {
                        print("❗️ERROR: Loading failed - \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
            }
            
            
            
            
        }  // VStack
        
    }  // some View
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("❗️Could not read file named \(soundName)")
            return
        }  // guard let
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription). Creating audioPlayer.")
        }  // do...catch
    }
    
    
    
}  // ContentView


#Preview {
    ContentView()
}
