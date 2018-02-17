//
//  TempViewController.swift
//  Benefit
//
//  Created by Delta One on 17/02/18.
//  Copyright © 2018 IOSD. All rights reserved.
//

import UIKit

class TempViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    let rows = ["PremiumFeatureCell", "CalendarCell", "TodaysNutritionPlan", "NutritionDiet", "CommentCell", "SavedMealCell"]
    let mealBackgroundColors = [UIColor(hex: "E0A662"), UIColor(hex: "73C997"), UIColor(hex: "457B97"), UIColor(hex: "C64A4D"), UIColor(hex: "2A373E")]
    let meals = ["Breakfast", "Mid-morning", "Lunch", "Snacks", "Dinner"]
    var isMealSaved = [false, false, false, false, false]
    var currentSection = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView()
    {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        for row in rows
        {
            if row != "CalendarCell" && row != "TodaysNutritionPlan"
            {
                registerCellNib(named: row, with: tableView)
            }
        }
        hideKeyboard()
    }
}

extension TempViewController: CalendarViewControllerDelegate
{
    func respondToChangeInSelectedDate(for dayNumber: Int, _ month: String, _ year: Int)
    {
        print(dayNumber, month, year)
    }
}

extension TempViewController: UITableViewDataSource, CommentMealDelegate
{
    func commentMealTextViewDidBeginEditing(on row: Int)
    {
        tableView.scrollToRow(at: IndexPath(row: 1, section: row + 3), at: .middle, animated: true)
    }
    
    func saveButtonPressed(with comment: String, on row: Int)
    {
        saveMeal(with: comment, for: row)
    }
    
    func saveMeal(with commment: String, for row: Int)
    {
        updateSaveSectionUI(for: row)
    }
    
    func updateSaveSectionUI(for row: Int)
    {
        isMealSaved[row] = true
        //let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 1, section: row + 3), at: .middle, animated: false)
        //tableView.setContentOffset(contentOffset, animated: true)
       // tableView.contentOffset = contentOffset
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return rows.count + meals.count - 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section <= 2
        {
            return 1
        }
        else
        {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumFeatureCell", for: indexPath) as! PremiumFeatureCell
            cell.leftLogoImageView.image = #imageLiteral(resourceName: "ic_my_nutrition_24dp")
            cell.lockImageView.image = UIImage()
            cell.titleLabel.textColor = UIColor.black
            cell.titleLabel.text = "MY NUTRITION PLAN"
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath)
            let calendarView = cell.contentView.viewWithTag(13) as! MyCalendar
            calendarView.delegateForHandlingDates = self
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysNutritionPlan", for: indexPath)
            return cell
        }
        else
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionDiet", for: indexPath) as! NutritionDiet
                cell.mealName.text = meals[indexPath.section - 3]
                cell.mealPlanBackgroundView.backgroundColor = mealBackgroundColors[indexPath.section - 3]
                cell.selectionStyle = .none
                //currentSection = indexPath.section
                return cell
            }
            else
            {
                if isMealSaved[indexPath.section - 3]
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMealCell", for: indexPath)
                
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                    cell.delegate = self
                    cell.row = indexPath.section - 3
                    return cell
                }
                
            }
        }
    }
}

