//
//  WeeklyViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit
import Highcharts
class WeeklyViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var statusImagePath: UIImageView!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var temperatureValue: UILabel!
    var city: String!
    //file scope variable
    @IBOutlet weak var navigation: UINavigationItem!
    var chartData:[Any] = []
    var chartView: HIChartView!
    var weeklyWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    var dailyWeather = DailyWeatherModel(dayCells:  [])
    override func viewDidLoad() {
        super.viewDidLoad()
        //static setting
        navigation.title = city
        titleView.layer.borderColor = UIColor.white.cgColor
        //operation right after loading view
        refreshPage()
        //Chart
        //get dataset for chart
        for (index,item) in dailyWeather.dayCells.enumerated()
        {
//            chartData.append([item.getDateTimestamp() * 1000, item.getTemperatureMaxFloat(), item.getTemperatureMinFloat()])
            chartData.append([index,Int(item.getTemperatureMinFloat()), Int(item.getTemperatureMaxFloat())])
        }
        print(chartData)
        drawChart()
        
        
    }
    func refreshPage()
    {
        self.statusImagePath.image = UIImage(named: self.weeklyWeather.getImageName())
        self.temperatureValue.text = self.weeklyWeather.getTemperatureText()
        self.statusValue.text = self.weeklyWeather.getStatusText()
    }
    func drawChart()
    {
        //chart configure
        chartView = HIChartView(frame: CGRect(x: 0, y: K.chartYCoordinate, width: K.screenWidth, height: K.chartHeight))
        let options = HIOptions()
        let chart = HIChart()
        chart.type = "arearange"
        options.chart = chart
        let title = HITitle()
        title.text = "Temperature Variation by Day"
        options.title = title
        // XAxis
        let xAxis = HIXAxis()
        xAxis.type = "number"
        options.xAxis = [xAxis]
        // YAxis
        let yAxis = HIYAxis()
            yAxis.title = HITitle()
            yAxis.title.text = "Temperature"
            options.yAxis = [yAxis]
        //Legend
        let legend = HILegend()
            legend.enabled = false
            options.legend = legend
        //plot options
        let plotOptions = HIPlotOptions()
        plotOptions.arearange = HIArearange()
        plotOptions.arearange.fillColor = HIColor(linearGradient: ["x1": 1, "y1": 0, "x2:": 0, "y2": 1],stops: [[0, "#ef8e38"], [1, "#71b4eb"]])
        plotOptions.arearange.marker = HIMarker()
        plotOptions.arearange.color = HIColor(hexValue: "#000000")
        plotOptions.arearange.marker.radius = 4
        options.plotOptions = plotOptions
        //tooltip
        let tooltip = HITooltip()
        tooltip.valueSuffix = " °F"
        tooltip.shared = true
        tooltip.split = true
        options.tooltip = tooltip
        //date
        let area = HIArearange()
        area.data = chartData
        area.name = "Temperatures"
        options.series = [area]
        print(options.series)
        chartView.options = options
        view.addSubview(chartView)
    }
    
    
    @IBAction func twitterButtonOnPressed(_ sender: Any) {
        
        let twitterText = "The current temperature at \(self.city!) is \(self.weeklyWeather.getTemperatureText()). The weather conditions are \(self.weeklyWeather.getStatusText()!)#CSCI571WeatherSearch"
        let EncodedTwitterText = twitterText.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        guard let url = URL(string: "https://twitter.com/intent/tweet?text=" + EncodedTwitterText!) else { print("can't produce URL"); return }
        
        UIApplication.shared.open(url)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
