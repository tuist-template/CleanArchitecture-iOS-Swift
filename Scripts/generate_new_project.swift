#!/usr/bin/swift
import Foundation

func make_new_project(_ project_name: String,_ has_demo: Bool = false) {
    make_dir("\(project_name)")
    make_project_file(project_name, project_name, has_demo)
    make_sources(project_name)
    make_tests(project_name)
    if has_demo {
        make_demo(project_name)
    }
}
func write_code_in_file(_ file_path: String,_ codes: String) {
    if let data: Data = codes.data(using: .utf8) {
        do {
            try data.write(to: URL(fileURLWithPath: current_path + file_path))
        } catch let e {
            print("⚠️ Error - \(e.localizedDescription)")
        }
    }
}
func make_dir(_ path: String) {
    do {
        try fileManager.createDirectory(atPath: current_path+path, withIntermediateDirectories: false, attributes: nil)
    } catch let e {
        print("⚠️ Error - \(e.localizedDescription)")
    }
}
func make_dirs(_ paths: [String]) {
    paths.forEach{
        make_dir($0)
    }
}
func make_project_file(_ project_name: String,
                       _ file_path: String,
                       _ has_demo: Bool = false,
                       _ dependencies: [String] = []) {
    let project_path = file_path + "/Project.swift"
    let _ = file_path.split(separator: "/")
    let file_content = """
    import ProjectDescription
    import ProjectDescriptionHelpers
    
    let project = Project.makeModule(
        name: "\(project_name)",
        product: .staticFramework,
        dependencies: [
        ]\(has_demo ? ",\n    hasDemoApp: true" : "")
    )
    """
    write_code_in_file(project_path, file_content)
}
func make_sources(_ project_name: String) {
    make_dir("\(project_name)/Sources")
    let project_file_path = "\(project_name)/Sources/\(project_name).swift"
    let project_content = "// This is for tuist"
    write_code_in_file(project_file_path, project_content)
}
func make_tests(_ project_name: String) {
    make_dir("\(project_name)/Tests")
    let test_file_path = "\(project_name)/Tests/TargetTests.swift"
    let test_content = """
import XCTest

class TargetTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual("A", "A")
    }
}
"""
    write_code_in_file(test_file_path, test_content)
}
func make_demo(_ project_name: String) {
    make_dir("\(project_name)/Demo")
    make_dir("\(project_name)/Demo/Sources")
    make_dir("\(project_name)/Demo/Resources")
    let launch_path = "\(project_name)/Demo/Resources/LaunchScreen.storyboard"
    let launch = """
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="13122.16" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
        <dependencies>
            <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="13104.12"/>
            <capability name="Safe area layout guides" minToolsVersion="9.0"/>
            <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
        </dependencies>
        <scenes>
            <!--View Controller-->
            <scene sceneID="EHf-IW-A2E">
                <objects>
                    <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                        <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                            <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
                            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                            <color key="backgroundColor" xcode11CocoaTouchSystemColor="systemBackgroundColor" cocoaTouchSystemColor="whiteColor"/>
                            <viewLayoutGuide key="safeArea" id="6Tk-OE-BBY"/>
                        </view>
                    </viewController>
                    <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
                </objects>
                <point key="canvasLocation" x="53" y="375"/>
            </scene>
        </scenes>
    </document>
    """
    
    write_code_in_file(launch_path, launch)
    
    let app_delegate_path = "\(project_name)/Demo/Sources/AppDelegate.swift"
    let app_delegate = """
    @main
    class AppDelegate: UIResponder, UIApplicationDelegate {

        var window: UIWindow?

        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            window = UIWindow(frame: UIScreen.main.bounds)
            let viewController = UIViewController()
            viewController.view.backgroundColor = .yellow
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()

            return true
        }
    }
"""
    write_code_in_file(app_delegate_path, app_delegate)
}

print("Input new project root \n(Features/Modules/Services/UserInterfaces, default = Features) : ", terminator: "")
let root_path: String = readLine()?.replacingOccurrences(of: "\n", with: "") ?? ""
let project_path = root_path.isEmpty ? "Features" : root_path

print("Input new project name : ", terminator: "")
let project_name : String = readLine()?.replacingOccurrences(of: "\n", with: "") ?? ""

print("Include demo? (Y or N, default = N) : ", terminator: "")
let has_demo : Bool = readLine()?.replacingOccurrences(of: "\n", with: "").uppercased() == "Y"

print("Start to generate the new \(project_path.lowercased()) named \(project_name)...")

let current_path : String = "./Projects/\(project_path)/"
let fileManager : FileManager = .default

make_new_project(project_name, has_demo)
