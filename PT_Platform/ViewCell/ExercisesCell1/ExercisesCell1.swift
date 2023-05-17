//
//  ExercisesCell1.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 27/01/2022.
//

import UIKit


class ExercisesCell1: UITableViewCell {
    
    var Vc : ExercisesVC?
    var Vc2 : ChallengesVC?
    var Vc3 : PersonalTrainingVideoVC?
    var dataList = [ExercisesInM]()
    var dataListId = [CategoryM]()
    var dataListtraining = [NewsfeedM]()
        
    var model:CategoryM!{
        didSet{
            dataList = model.exercisesArray
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
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
        if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            getTrainingWorkout()
        }
        
    }
    
    func getTrainingWorkout(){
        ControllerService.instance.trainingWorkoutApi { category, bool, bool2 in
            if bool{
                if bool2{
                    self.dataListtraining = category
                    self.collectionView.reloadData()
                }else{
                    ToastView.shared.short((self.Vc3?.view)!, txt_msg: "Sothing wrong")
                }
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Authorized"), object: nil)
            }
        }
    }
    
}


extension ExercisesCell1 : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 , height: 205)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            return dataListtraining.count
        }
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainerCell", for: indexPath) as? TrainerCell
        if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            let Trainiing = dataListtraining[indexPath.row]
            cell?.lbl.text = Trainiing.title as? String ?? ""
            let image = Trainiing.image as? String ?? ""
            if image == ""{
                cell?.self.img.image = UIImage(named: "Trainer")
            }else{
                cell?.self.img.sd_setImage(with: URL(string: image), completed: nil)
            }
        }else{
            cell?.model = dataList[indexPath.row]
        }
            return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Shared.shared.btnBack == "Exercises" || Shared.shared.btnBack == "تمارين"{
            let Exercis = dataList[indexPath.row]
            Shared.shared.exercise_id = Exercis.id as? Int ?? 0
            Shared.shared.exercise_name = Exercis.title as? String ?? ""
            Shared.shared.exercise_description = Exercis.description as? String ?? ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavDetailsCellVC")
            controller.modalPresentationStyle = .fullScreen
            Vc?.present(controller, animated: true, completion: nil)
        }else if Shared.shared.btnBack == "Workouts" || Shared.shared.btnBack == "مجموعات"{
            let Exercis = dataList[indexPath.row]
            Shared.shared.exercise_id = Exercis.id as? Int ?? 0
            Shared.shared.exercise_name = Exercis.title as? String ?? ""
            Shared.shared.exercise_description = Exercis.description as? String ?? ""
            Shared.shared.exercise_img = Exercis.icon as? String ?? ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExploreDetailsVC")
            controller.modalPresentationStyle = .fullScreen
            Vc?.present(controller, animated: true, completion: nil)
        }else if Shared.shared.btnBack == "Personal Training" || Shared.shared.btnBack == "تمرين شخصي"{
            let Trainiing = dataListtraining[indexPath.row]
            Shared.shared.exercise_id = Trainiing.id as? Int ?? 0
            Shared.shared.exercise_name = Trainiing.title as? String ?? ""
            Shared.shared.exercise_description = Trainiing.description as? String ?? ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavDetailsCellVC")
            controller.modalPresentationStyle = .fullScreen
            Vc3?.present(controller, animated: true, completion: nil)
        }
        
    }
    
}
