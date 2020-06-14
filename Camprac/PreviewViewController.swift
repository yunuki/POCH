//
//  PreviewViewController.swift
//  Camprac
//
//  Created by woogie on 29/09/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imgData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //view가 올라오기 전에 captureSession의 인풋, 아웃풋 설정후 livePreview 띄움
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        do {
            let input = try AVCaptureDeviceInput(device: backCamera) //input을 후면카메라로 설정
            stillImageOutput = AVCapturePhotoOutput() //output을 AVCapturePhotoOutPut 객체로 설정
            //captureSession의 input과 output을 설정하고 livePreview를 띄움
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
                previewView.bringSubviewToFront(button) //button을 preview 앞으로
            }

        } catch let error{
            print("Error unable to initialize back camera: \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    func setupLivePreview() {
        //captureSession을 매개변수로 하여 AVCaptureVideoPreviewLayer 객체를 생성 후 display option 설정
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        
        //UIView의 subLayer로 videoPreviewLayer를 삽입
        previewView.layer.addSublayer(videoPreviewLayer)
        
        //captureSession을 구동시키고 videoPreviewLayer를 화면에 띄운다.
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    //버튼을 눌렀을 때 실행하는 action
    @IBAction func didTakePhoto(_ sender: Any) {
        //capture를 위한 옵션을 세팅하고 장면을 캡쳐한다.
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    //캡쳐를 했을 때 실행되는 delegate method
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //이미지 데이터 추출
        guard let imageData = photo.fileDataRepresentation() else {return}
        self.imgData = imageData
        //segue를 실행
        performSegue(withIdentifier: "resultSegue", sender: nil)
         
    }
    //다음 view로 segue가 일어날 때 실행되는 코드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {
            //다음 view에 대한 controller로 imageData를 보냄
            let vc = segue.destination as! ResultViewController
            vc.imageData = self.imgData
        }
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        
    }
}

