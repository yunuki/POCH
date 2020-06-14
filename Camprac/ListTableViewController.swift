//
//  ListTableViewController.swift
//  Camprac
//
//  Created by woogie on 25/10/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var caughtIngredients: [Ingredient] = []
    var selectedIndexPath: IndexPath!
    var pegCount: Int = 0
    var pegIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DesignHelper.Itself.setGradientToTableView(tableView: tableView, UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0), UIColor(red: 125/255.0, green: 125/255.0, blue: 255/255.0, alpha: 1.0))
        tableView.rowHeight = 100
        pegControl()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func pegControl() {
        for i in 0..<caughtIngredients.count {
            if caughtIngredients[i].name == "피이자" {
                pegCount += 1
                pegIndex.insert(i, at: 0)
            } else if caughtIngredients[i].name == "피이지" {
                pegCount += 1
                pegIndex.append(i)
            }
        }
        if pegCount > 1 {
            for i in 0..<pegIndex.count-1 {
                caughtIngredients.remove(at: pegIndex[i])
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caughtIngredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        //피이지 혹은 피이지-의 경우 중복되는 명칭이 많으므로 그것들의 수를 세서 하나의 셀에 "피이지 - ()개" 형식으로 표현
        if caughtIngredients[indexPath.row].name == "피이지" || caughtIngredients[indexPath.row].name == "피이자" {
            cell.textLabel?.text = "피이지" + " - \(pegCount)개"
            cell.detailTextLabel?.text = caughtIngredients[indexPath.row].engName
        } else {
            // 피이지가 아닐 경우 indexPath.row에 해당하는 caughtIngredients의 name과 engName을 각 cell의 textLabel과 detailTextLabel로 설정
            cell.textLabel?.text = caughtIngredients[indexPath.row].name
            cell.detailTextLabel?.text = caughtIngredients[indexPath.row].engName
        }
        // Configure the cell...

        return cell
    }
    
    // cell을 선택하면 그 cell에 해당하는 유해 성분 객체를 다음 Controller로 보내고 화면을 전환한다
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath //선택한 cell의 indexPath
        performSegue(withIdentifier: "moreDetailSegue", sender: nil) //moreDetailSegue 실행
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreDetailSegue" {
            let vc = segue.destination as! DetailViewController
            vc.ingre = caughtIngredients[selectedIndexPath.row] //선택한 cell에 해당하는 유해 성분 객체를 보냄
        }
    }

}
