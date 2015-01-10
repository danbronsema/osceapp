//
//  ExaminationCompleteViewController.swift
//  osceApp
//
//  Created by Daniel Bronsema on 30/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class ExaminationCompleteViewController: UIViewController {

    var currentExamination : NSMutableDictionary!
    var currentExaminationName: String?
    var currentExaminationColor: UIColor?
    var currentExaminationScore : Int?
    var currentExaminationProcedures : NSMutableArray?
    
    let quoteArray = [
        "Isn’t it a bit unnerving that doctors call what they do 'practice'? - George Carlin",
        "Let food be thy medicine and medicine be thy food. - Hippocrates",
        "As to diseases, make a habit of two things — to help, or at least, to do no harm. - Hippocrates",
        "The physician should not treat the disease but the patient who is suffering from it. - Maimonides",
        "In nothing do men more nearly approach the gods than in giving health to men. - Cicero",
        "The greatest mistake in the treatment of diseases is that there are physicians for the body and physicians for the soul, although the two cannot be separated. - Plato",
        "It is a mathematical fact that fifty percent of all doctors graduate in the bottom half of their class. - Unknown",
        "One of the first duties of the physician is to educate the masses not to take medicine.... Soap and water and common sense are the best disinfectants. - William Osler",
        "When you are called to a sick man, be sure you know what the matter is — if you do not know, nature can do a great deal better than you can guess. - Nicholas de Belleville",
        "Diagnosis is not the end, but the beginning of practice. - Martin H. Fischer",
        "A physician is obligated to consider more than a diseased organ, more even than the whole man — he must view the man in his world. - Harvey Cushing",
        "Never forget that it is not a pneumonia, but a pneumonic man who is your patient. - William Withey Gull",
        "When you treat a disease, first treat the mind. - Chen Jen",
        "The doctor may also learn more about the illness from the way the patient tells the story than from the story itself. - James B. Herrick",
        "Let the young know they will never find a more interesting, more instructive book than the patient himself. - Giorgio Baglivi"
    ]
    
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, nil)
    }
    @IBOutlet weak var examinationCompleteBg: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var particles: ParticleView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        examinationCompleteBg.layer.cornerRadius = 10
        examinationCompleteBg.alpha = 0.0
        self.examinationCompleteBg.transform = CGAffineTransformMakeTranslation(0, -250)
        spring(0.7, { () -> Void in
            self.examinationCompleteBg.alpha = 1
            self.examinationCompleteBg.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    override func viewWillDisappear(animated: Bool) {
        spring(0.7, { () -> Void in
            self.examinationCompleteBg.alpha = 0
            self.examinationCompleteBg.transform = CGAffineTransformMakeTranslation(0, 100)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String("\(currentExaminationScore!)%")
        scoreLabel.textColor = currentExaminationColor
        if currentExaminationScore > 80 {
            particles.drawParticles()
        }
        let name = currentExaminationName!.capitalizedString
        self.titleLabel.text = "\(name) Examination Complete!"
        let randomQuoteInt = Int(arc4random_uniform(UInt32(quoteArray.count)))
        quoteLabel.text = quoteArray[randomQuoteInt]
   }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var examinationViewController = segue.destinationViewController as ExaminationViewController
        examinationViewController.currentExamination = currentExamination
        examinationViewController.currentExaminationColor = currentExaminationColor
        examinationViewController.currentExaminationName = currentExaminationName
        examinationViewController.currentExaminationProcedures = currentExaminationProcedures
    }

}
