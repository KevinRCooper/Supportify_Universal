//
//  AppData.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

class AppData: ObservableObject {
    @Published var showingPromotional: Bool = false
    // MARK: - Navigation
    @Published var showingNavBar: Bool = true
    // Tracks if side-bar navigation is loaded to fix the text preview
    @Published var sidebarNavigationInView: Bool = false
    // Tracks if Overlay Options screen has been seen
    @Published var userSeenOverlayScreen: Bool = false
    
    // MARK: - LGBTQ+ Identification
    // Community Identification Choices
    @Published var communityIdentificationChoice: Array = [NSLocalizedString("LGBTQ+", comment: ""), NSLocalizedString("LGBTQ+ Ally", comment: "")]
    // Community Identification Selected Choice
    @Published var communityIdentification = "LGBTQ+"

    // MARK: - Image Handling
    @Published var hasImageBeenSelected: Bool = false
    // Image Position Offsets, Zoom, and Finger Locations
    @Published var imageXOffset : Double = 0.0
    @Published var imageYOffset : Double = 0.0
    @Published var zoomLevel: Double = 1.0
    @Published var location: CGPoint?
    @Published var circleLocation: CGPoint?
    @Published var imageFrame: CGFloat  = 0.5
    @Published var outputImageSize: CGPoint = CGPoint(x: 500, y: 500)
    @Published var showingSizeOptions: Bool = false
    @Published var showingDoneScreen: Bool = false
    // Stores Image Outline Stroke
    @Published var imageDisplayLineWidth: CGFloat = 5
    // Image Display Choice Selection Array
    @Published var imageDisplayChoice : Array = [NSLocalizedString("Banner", comment: ""), NSLocalizedString("Circle Gradient", comment: "")]
    // Stores the Image Choice Selection
    @Published var imageDisplay: String = "Banner"
    
    // MARK: - Alerts
    // Showing Save Alert
    @Published var showingSaveAlert: Bool = false
    // Blur for Alert
    @Published var alertBackgroundViewBlur: Double = 20.0
    // Counter for Confetti
    @Published var counter: Int = 0
    
    #if !os(macOS)
    // Photo Picker Source Type
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    // Stores selected Image
    @Published var selectedImage: UIImage?
    #else
    @Published var inputUrl: URL?
    @Published var outputUrl: String?
    @Published var inputImage: NSImage?
    @Published var outputImage: NSImage?
    @Published var selectedImage: NSImage?
    
    
    //MARK: - Open Image on macOS
    func openImage() {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select File"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["png","jpg","jpeg"]
        let response = openPanel.runModal()
        if response == .OK {
            self.inputUrl = openPanel.url
            self.inputImage = NSImage(contentsOf: self.inputUrl!)
            print("Image Uploaded")
        } else {
            self.inputUrl = nil
            print("Error uploading image")
        }
    }
    
    //MARK: - Save Panel on macOS
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = NSLocalizedString("Save your image", comment: "")
        savePanel.message = NSLocalizedString("Choose a folder and a name to store the image.", comment: "")
        savePanel.nameFieldLabel = NSLocalizedString("Image file name:", comment: "")
        savePanel.nameFieldStringValue = NSLocalizedString("ProfileImage", comment: "")
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    //MARK: - Save Image on macOS
    func saveImage(appData: AppData) {
        let path = showSavePanel()
        self.outputImage = ImageOverlayWrapper().environmentObject(appData).snapshot()
        let image = self.outputImage
        let imageRepresentation = NSBitmapImageRep(data: image!.tiffRepresentation!)
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])
        do {
            try pngData!.write(to: path!)
        } catch {
            print(error)
        }
    }
    #endif
    
    // MARK: - Flag Selection
    @Published var selectedFlagName = NSLocalizedString("6-Color Pride Flag", comment: "")
    
    // Flag List
    @Published var flagsList : [Flags] = [
        Flags(id: 0,
              name: NSLocalizedString("Gilbert Pride Flag", comment: ""),
              image: "Gilbert_Pride_Flag",
              selected: false
             ),
        Flags(id: 1,
              name: NSLocalizedString("6-Color Pride Flag", comment: ""),
              image: "6-Color_Pride_Flag",
              selected: true
             ),
        Flags(id: 2,
              name: NSLocalizedString("Philadelphia Pride Flag", comment: ""),
              image: "Philadelphia_Pride_Flag",
              selected: false
             ),
        Flags(id: 3,
              name: NSLocalizedString("Transgender Pride Flag", comment: ""),
              image: "Transgender_Pride_Flag",
              selected: false
             ),
        Flags(id: 4,
              name: NSLocalizedString("Progress Pride Flag", comment: ""),
              image: "Progress_Pride_Flag",
              selected: false
             )
    ]
    
    @Published var gilbertFlag : [Color] = [
        Color("gilbertLavender"),
        Color("gilbertPink"),
        Color("gilbertRed"),
        Color("gilbertOrange"),
        Color("gilbertYellow"),
        Color("gilbertGreen"),
        Color("gilbertTurquoise"),
        Color("gilbertIndigo"),
        Color("gilbertViolet")
    ]
    
    @Published var sixColorFlag : [Color] = [
        Color("prideRed"),
        Color("prideOrange"),
        Color("prideYellow"),
        Color("prideGreen"),
        Color("prideIndigo"),
        Color("prideViolet")
    ]
    
    @Published var philadelphiaFlag : [Color] = [
        Color("philBlack"),
        Color("philBrown"),
        Color("philRed"),
        Color("philOrange"),
        Color("philYellow"),
        Color("philGreen"),
        Color("philBlue"),
        Color("philVioletPurple")
    ]
    
    // Transgender Pride Flag
    @Published var transgenderFlag : [Color] = [
        Color("transgenderMayaBlue"),
        Color("transgenderPink"),
        Color("transgenderWhite"),
        Color("transgenderPink"),
        Color("transgenderMayaBlue")
    ]
    // Progress Pride Flag
    @Published var progressFlag : [Color] = [
        Color("progressRed"),
        Color("progressOrange"),
        Color("progressYellow"),
        Color("progressGreen"),
        Color("progressIndigo"),
        Color("progressViolet"),
        Color("progressWhite"),
        Color("progressPink"),
        Color("progressBlue"),
        Color("progressBrown"),
        Color("progressBlack")
    ]
    
    // Default Pride Colors
    @Published var prideColors = [
        Color("prideRed"),
        Color("prideOrange"),
        Color("prideYellow"),
        Color("prideGreen"),
        Color("prideIndigo"),
        Color("prideViolet")
    ]
    
    func getPrideFlagColors(selection: String, type: String) -> [Color] {
        if type == "gradient" {
            if selection == "Gilbert Pride Flag" { return gradientArray(inputArray: gilbertFlag)}
            if selection == "6-Color Pride Flag" { return gradientArray(inputArray: sixColorFlag)}
            if selection == "Philadelphia Pride Flag" { return gradientArray(inputArray: philadelphiaFlag)}
            if selection == "Transgender Pride Flag" { return gradientArray(inputArray: transgenderFlag)}
            if selection == "Progress Pride Flag" { return gradientArray(inputArray: progressFlag)}
        } else {
            if selection == "Gilbert Pride Flag" { return gilbertFlag }
            if selection == "6-Color Pride Flag" { return sixColorFlag }
            if selection == "Philadelphia Pride Flag" { return philadelphiaFlag }
            if selection == "Transgender Pride Flag" { return transgenderFlag }
            if selection == "Progress Pride Flag" { return progressFlag }
        }
        return []
    }
    
    func gradientArray(inputArray: [Color]) -> [Color] {
        var newArray = inputArray
        let firstArrayItem = newArray[0]
        newArray.append(firstArrayItem)
        return newArray
    }
    
    func bannerWidth(selection: String) -> CGFloat {
        if selection == "Gilbert Pride Flag" { return 29.0 }
        if selection == "6-Color Pride Flag" { return 45.0 }
        if selection == "Philadelphia Pride Flag" { return 32.0 }
        if selection == "Transgender Pride Flag" { return 60.0 }
        if selection == "Progress Pride Flag" { return 23.0 }
        return 40
    }
}

struct Flags: Identifiable {
    let id : Int
    var name : String
    let image : String
    var selected : Bool
}
