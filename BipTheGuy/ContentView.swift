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
            
            /*
             .onChange(of: selectedPhoto) { _, newValue in
             
             Steps needed to get image
             Get the data inside the PhotosPickerItem selectedPhoto.
             Use the data to create a UIImage.
             Use the UIImage to create an image.
             Assign that image to bipImage.
             
             
             First way to do this ->
             
             Task {
             do {
             if let data = try await newValue?.loadTransferable(type: Data.self) {
             if let uiImage = UIImage(data: data) {
             bipImage = Image(uiImage: uiImage)
             }
             }
             } catch {
             print("😡 ERROR: Loading failed! \(error.localizedDescription)")
             }  // do...catch
             
             }  // Task
             
             
             
             Second way to do this ->
             // Don't care about the error???
             
             Task {
             guard let data = try? await newValue?.loadTransferable(type: Data.self) else {
             print("😡 ERROR: Couldn't get data from loadTransferable!")
             return
             }  // guard let
             
             let uiImage = UIImage(data: data) ?? UIImage()
             bipImage = Image(uiImage: uiImage)
             // if an error is thrown after try? the curlies won't execute but error is ignored (nil).
             }  // Task
             
             
             // Third way
             
             Task {
             if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
             let uiImage = UIImage(data: data) ?? UIImage()
             bipImage = Image(uiImage: uiImage)
             // If an error is thrown after try? curlies won't execute and error is ignored (nil)
             }  // if let
             }  // Task
             
             */
            
            .onChange(of: selectedPhoto) { _, newValue in
                //                Task {
                //                    do {
                //                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                //                            if let uiImage = UIImage(data: data) {
                //                                bipImage = Image(uiImage: uiImage)
                //                            }
                //                        }
                //                    } catch {
                //                        print("😡 ERROR: Loading failed! \(error.localizedDescription)")
                //                    }  // do...catch
                //
                //                }  // Task
                //            }  // .onChange
                
                Task {
                    do {
                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                bipImage = Image(uiImage: uiImage)
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
