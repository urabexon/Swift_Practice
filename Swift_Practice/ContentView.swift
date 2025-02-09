//
//  ContentView.swift
//  Swift_Practice
//
//  Created by 卜部大輝 on 2025/02/09.
//

import SwiftUI
import Foundation

struct ContentView: View {
    // MARK: - 状態変数
    @State private var typeOfNumber: String = "length"         // 測定項目（"temperature", "length", "time", "volume" など）
    @State private var enteredNumber: Double = 0                // 入力された数値
    @State private var originalUnit: String = "meters"          // 換算前の単位
    @State private var conversionUnit: String = "kilometers"    // 換算後の単位
    @State private var selectedUnits: [String] = []             // 現在の測定項目に対応する単位一覧

    // MARK: - 定数
    let typesOfNumber: [String] = ["temperature", "length", "time", "volume"]
    let lengthUnits: [String] = ["meters", "kilometers", "feet", "yards", "miles"]
    let temperatureUnits: [String] = ["Celsius", "Fahrenheit"]  // 温度の単位
    
    var body: some View {
        NavigationStack {
            Form {
                // 測定項目の選択セクション
                Section("Measurement type") {
                    Picker("Type of Number", selection: $typeOfNumber) {
                        ForEach(typesOfNumber, id: \.self) { type in
                            Text(type)
                                .foregroundStyle(.blue)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                // 元の数値入力と単位選択セクション
                Section("元の数値") {
                    HStack {
                        TextField("Original", value: $enteredNumber, format: .number)
                            .keyboardType(.decimalPad)
                            .padding()
                        Picker("", selection: $originalUnit) {
                            ForEach(selectedUnits, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                // 換算後の数値表示と単位選択セクション
                Section("換算後の数値") {
                    HStack {
                        Text(
                            // 測定項目が "length" の場合は変換処理を実施
                            typeOfNumber == "length" ?
                                Conversion.lengthConversion(oldUnit: originalUnit,
                                                            newUnit: conversionUnit,
                                                            value: enteredNumber) :
                                enteredNumber,
                            format: .number
                        )
                        .padding()
                        
                        Picker("", selection: $conversionUnit) {
                            ForEach(selectedUnits, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Unit Convertor")
            // 画面表示時に現在の測定項目に応じた単位一覧を設定
            .onAppear {
                selectedUnits = setUnits(typeOfNumber: typeOfNumber)
            }
            // 測定項目が変更された際に単位一覧を更新
            .onChange(of: typeOfNumber) { newValue in
                selectedUnits = setUnits(typeOfNumber: newValue)
            }
        }
    }
    
    // MARK: - 単位一覧の設定
    func setUnits(typeOfNumber: String) -> [String] {
        var units: [String] = []
        switch typeOfNumber {
        case "length":
            units = lengthUnits
        case "temperature":
            units = temperatureUnits
        default:
            // 他の測定項目については、ここで適切な単位一覧を設定してください
            units = []
        }
        
        // 単位一覧が2つ以上ある場合、初期表示の単位を設定
        if units.count >= 2 {
            // 例：換算後の単位を先頭、換算前の単位を2番目に設定
            conversionUnit = units[0]
            originalUnit = units[1]
        } else if let first = units.first {
            conversionUnit = first
            originalUnit = first
        }
        return units
    }
}

struct Conversion {
    // MARK: - 長さの単位変換処理（静的メソッド）
    static func lengthConversion(oldUnit: String, newUnit: String, value: Double) -> Double {
        let metersValue = toMeters(lengthUnit: oldUnit, value: value)
        return fromMetersToAnother(lengthUnit: newUnit, metersValue: metersValue)
    }
    
    /// 入力された値（指定の単位）をメートル単位に変換する
    static func toMeters(lengthUnit: String, value: Double) -> Double {
        switch lengthUnit {
        case "meters":
            return value
        case "kilometers":
            return value * 1000       // 1 km = 1000 m
        case "feet":
            return value / 3.28084    // 1 m ≒ 3.28084 ft
        case "yards":
            return value / 1.09361    // 1 m ≒ 1.09361 yd
        case "miles":
            return value * 1609.34    // 1 mile ≒ 1609.34 m
        default:
            return value
        }
    }
    
    /// メートル単位の値を指定の単位に変換する
    static func fromMetersToAnother(lengthUnit: String, metersValue: Double) -> Double {
        switch lengthUnit {
        case "meters":
            return metersValue
        case "kilometers":
            return metersValue / 1000
        case "feet":
            return metersValue * 3.28084
        case "yards":
            return metersValue * 1.09361
        case "miles":
            return metersValue / 1609.34
        default:
            return metersValue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
