//
//  ListNotificationCell.swift
//  Uni
//
//  Created by nguyen gia huy on 27/12/2020.
//

import UIKit
import Charts
class ListNotificationCell: UITableViewCell {

    @IBOutlet weak var viewLeft3: UIView!
    @IBOutlet weak var viewLeft2: UIView!
    @IBOutlet weak var viewLeft1: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var stackViewBtHide: UIStackView!
    @IBOutlet weak var btHide: UIButton!
    @IBOutlet weak var btShow: UIButton!
    @IBOutlet weak var stackViewChart: UIStackView!
    @IBOutlet weak var viewChart: PieChartView!
    @IBOutlet weak var lbDate: UILabel!
    
    
    var hideViewChart: (()->Void)? = nil
    var showViewChart: (()->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()

        
    }
    
    func setupUI(){
        viewLeft1.backgroundColor = AppColor.YellowFAB32A
        viewLeft2.backgroundColor = AppColor.YellowFAB32A
        viewLeft3.backgroundColor = AppColor.YellowFAB32A
        lbDateTime.textColor = AppColor.YellowFAB32A
        lbDate.textColor = AppColor.YellowFAB32A
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        
        // Configure the view for the selected state
    }
    
    func customizeChart(values: [Double]) {
        // 1. Set ChartDataEntry
        let dataPoints = [AppLanguage.Seen.localized, AppLanguage.Total.localized]
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        viewChart.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
        colors = [AppColor.BlueADEAFE,AppColor.OrangeF3D08E]
      return colors
    }
    @IBAction func actionHide(_ sender: Any) {
        hideViewChart?()
    }
    @IBAction func actionShow(_ sender: Any) {
        showViewChart?()
    }
    
}
