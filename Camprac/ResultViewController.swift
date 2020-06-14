//
//  ResultViewController.swift
//  Camprac
//
//  Created by woogie on 29/09/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit
import Firebase

extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .useUnicodeWordBoundaries)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map{
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            return []
        }
    }
}

class ResultViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var imageData: Data?
    var vision: Vision!
    var textRecognizer: VisionTextRecognizer!
    var image: VisionImage?
    var harmfuls: [String] = []
    var caughtIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vision = Vision.vision()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["ko", "en"]
        textRecognizer = vision.cloudTextRecognizer(options: options)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = imageData {
            self.imageView.image = UIImage(data: data)
            image = VisionImage(image: imageView.image!)
        }
        
        //이미지에서 전체 텍스트를 인식하고 정규표현식을 사용하여 유해 성분을 찾아낸다.
        textRecognizer.process(image!) { (result, error) in
            guard error == nil, let result = result else {return}
            //전체 텍스트에서 유해 성분을 찾아내어 harfuls 배열에 추가
            for block in result.blocks {
                let aString = block.text.replacingOccurrences(of: "\n", with: "")
                print(aString)
                for ingredient in Ingredient.dummyData {
                    self.harmfuls += aString.getArrayAfterRegex(regex: ingredient.name)
                }
            }
            //harmfuls 배열과 같은 이름을 가진 성분(=유해 성분) 객체를 caughtIngredients 배열에 추가
            for harmful in self.harmfuls {
                for harmfulIngredient in Ingredient.dummyData {
                    if harmful == harmfulIngredient.name {
                        self.caughtIngredients.append(harmfulIngredient)
                    }
                }
            }
            
            //caughtIngredients 배열이 비어있으면 3-1 View로, 아니면 3-2 View로 segue 실행
            if self.caughtIngredients.count == 0 {
                self.performSegue(withIdentifier: "noSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "detailSegue", sender: nil)
            }
            
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! ListTableViewController
            vc.caughtIngredients = caughtIngredients
        }
    }

}

