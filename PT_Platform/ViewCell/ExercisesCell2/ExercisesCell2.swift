//
//  ExercisesCell2.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 27/01/2022.
//

import UIKit
import LanguageManager_iOS

struct Model6 {
    let text: String
    let imageName: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
    }
}

class ExercisesCell2: UITableViewCell {

    var models6 = [Model6]()
    var datalistRecipes = [RecipesM]()
    var Vc : ExercisesVC?
    var Vc2 : ChallengesVC?
    var Vc3 : PersonalTrainingVideoVC?

    
    @IBOutlet weak var lblTilte: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TrainerCell", bundle: nil), forCellWithReuseIdentifier: "TrainerCell")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Shared.shared.btnBack == "Exercises"{
            addData61()
        }else if Shared.shared.btnBack == "Workouts"{
            addData62()
        }else if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            getTrainingRecipesdata()
        }else if Shared.shared.btnBack == "Challenges"{
            addData64()
        }

    }
    
    func getTrainingRecipesdata(){
        ControllerService.instance.trainingRecipeApi { category, bool in
            if bool{
                self.datalistRecipes = category
                self.collectionView.reloadData()
            }else{
//                ToastView.shared.short(self.view, txt_msg: "Sothing wrong")
            }
        }
    }
    
    func addData61() {
        models6.append(Model6(text: "Barbell Curl", imageName: "Trainer"))
        models6.append(Model6(text: "Hammer Curl", imageName: "Trainer"))
        models6.append(Model6(text: "Cable Curl", imageName: "Trainer"))
    }
    
    func addData62() {
        models6.append(Model6(text: "Stay healthy", imageName: "Trainer"))
        models6.append(Model6(text: "Upper Body", imageName: "Trainer"))
    }
    
    func addData63() {
        models6.append(Model6(text: "Stay healthy", imageName: "Trainer"))
        models6.append(Model6(text: "Upper Body", imageName: "Trainer"))
    }
    
    func addData64() {
        models6.append(Model6(text: "Morning Workout", imageName: "Trainer"))
        models6.append(Model6(text: "Strong Workout", imageName: "Trainer"))
        models6.append(Model6(text: "Morning Workout", imageName: "Trainer"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ExercisesCell2 : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 , height: 205)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            return datalistRecipes.count
        }
        return models6.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            let Trainiing = datalistRecipes[indexPath.row]
            cell?.lbl.text = Trainiing.title as? String ?? ""
            let image = Trainiing.image as? String ?? ""
            if image == ""{
                cell?.self.img.image = UIImage(named: "Trainer")
            }else{
                cell?.self.img.sd_setImage(with: URL(string: image), completed: nil)
            }
        }else{
            cell?.SetData(data: models6[indexPath.row])
        }
        cell?.lbl.font = UIFont.systemFont(ofSize: 15.0)

            return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Shared.shared.btnBack == "Exercises"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DetailsCellVC")
            controller.modalPresentationStyle = .fullScreen
            Vc?.present(controller, animated: true, completion: nil)
        }else if Shared.shared.btnBack == "Workouts"{
        }else if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            if LanguageManager.shared.currentLanguage == .en{
                Shared.shared.btnSubBack = "Recipes and Diet Plans"
            }else{
                Shared.shared.btnSubBack = "الوصفات وخطة الحمية"
            }
            Shared.shared.NewsImage = datalistRecipes[indexPath.row].image as! String
            Shared.shared.NewsTitle = datalistRecipes[indexPath.row].title as! String
            Shared.shared.NewsDescription = datalistRecipes[indexPath.row].description as! String
            Shared.shared.RecipesName = datalistRecipes[indexPath.row].name as! String
            Shared.shared.RecipesTime = "\(datalistRecipes[indexPath.row].time as! Int)"
            Shared.shared.RecipesIngredients = datalistRecipes[indexPath.row].ingredient as! String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "RecipesVC")
            Vc3?.self.navigationController?.pushViewController(controller, animated: true)
        }else if Shared.shared.btnBack == "Challenges"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChallengedCompleteVC")
            controller.modalPresentationStyle = .fullScreen
            Vc2?.present(controller, animated: true, completion: nil)
        }
        
        

    }
    
}
