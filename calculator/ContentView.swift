//
//  ContentView.swift
//  calculator
//
//  Created by Bruno on 27/05/24.
//

import SwiftUI

// Creamos el color primario de la app
let primaryColor = Color.init(red: 0, green: 116/255, blue: 178/255, opacity: 1.0)

struct ContentView: View {
    
    @State var finalValue: String = "DigitalCurry Recipe"
    @State var calExpression: [String] = []
    @State var noBeignEntered: String = ""
    
    let rows = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "−"],
        [".", "0", "=", "+"]]
    
    var body: some View {
        VStack {
            
            // Display de la calculadora
            VStack {
                
                // Resultado de las operaciones
                Text(self.finalValue)
                    .font(Font.custom("HelveticaNeue-Thin", size: 78))
                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                    .foregroundStyle(.white)
                
                // Display de las operaciones
                Text(flattenTheExpression(exps: calExpression))
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .frame(alignment: .bottomTrailing)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(primaryColor)
            
            // Display de los numeros (botones)
            VStack {
                Spacer(minLength: 48)
                
                VStack {
                    
                    // Botones en horizontal (filas)
                    ForEach(rows, id: \.self) { row in
                        HStack(alignment: .top, spacing: 0) {
                            Spacer(minLength: 10)
                            
                            // ciclo de las columnas
                            ForEach(row, id: \.self) { column in
                                Button(action: {
                                    if column == "=" {
                                        self.calExpression = []
                                        self.noBeignEntered = ""
                                        return
                                    } else if checkIfOperator(str: column) {
                                        self.calExpression.append(column)
                                        self.noBeignEntered = ""
                                    } else {
                                        self.noBeignEntered.append(column)
                                        
                                        if self.calExpression.count == 0 {
                                            self.calExpression.append(self.noBeignEntered)
                                        } else {
                                            if !checkIfOperator(str: self.calExpression[self.calExpression.count-1]) {
                                                self.calExpression.remove(at: self.calExpression.count-1)
                                            }
                                            
                                            self.calExpression.append(self.noBeignEntered)
                                        }
                                    }
                                    
                                    self.finalValue = processExpression(exp: self.calExpression)
                                    
                                    if self.calExpression.count > 3 {
                                        self.calExpression = [self.finalValue, self.calExpression[self.calExpression.count-1]]
                                    }
                                }, label: {
                                    Text(column)
                                        .font(.system(size: getFontSize(btnTxt: column)))
                                        .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                })
                                .foregroundStyle(.white)
                                .background(getBackground(str: column))
                                .mask(CustomShape(radius: 40, value: column))
                            }
                        }
                    }
                }
            }
            .background(.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 414, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(.black)
        .ignoresSafeArea(.all)
    }
}

// funcion para mostrar las expresiones en la calculadora
func flattenTheExpression(exps: [String]) -> String {
    var calExp = ""
    
    for exp in exps {
        calExp.append(exp)
    }
    
    return calExp
}

// funcion que muestra el color del background dependiento de que boton es
func getBackground(str: String) -> Color {
    if checkIfOperator(str: str) {
        return primaryColor
    }
    
    return Color.black
}

// Muestra el tamanio de icono en el boton
func getFontSize(btnTxt: String) -> CGFloat {
    if checkIfOperator(str: btnTxt) {
        return 32
    }
    
    return 24
}

// esta fucion comprueba si el icono es para una operacion o es un numero
func checkIfOperator(str: String) -> Bool {
    if str == "/" || str == "*" || str == "−" || str == "+" || str == "=" {
        return true
    }
    
    return false
}

// funcion que evalua la operacion y nos trae el resultado
func processExpression(exp: [String]) -> String {
    if exp.count < 3 {
        return "0.0"
    }
    
    var a = Double(exp[0])
    var c = Double("0.0")
    let expSize = exp.count
    
    for i in (1...expSize-2) {
        c = Double(exp[i+1])
        
        switch exp[i] {
        case "+":
            a! += c!
        case "-":
            a! -= c!
        case "*":
            a! *= c!
        case "/":
            a! /= c!
        default:
            print("skipping the rest")
        }
    }
    
    return String(format: "%.1f", a!)
}

// Con esta struct sacamos las coordenadas para
// darle cierto borde redondo a algunos botones seleccionados
struct CustomShape: Shape {
    let radius: CGFloat
    let value: String
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = CGPoint(x: rect.minX, y: rect.minY)
        let tr = CGPoint(x: rect.maxX, y: rect.minY)
        let br = CGPoint(x: rect.maxX, y: rect.maxY)
        let bl = CGPoint(x: rect.minX, y: rect.maxY)
        
        let tls = CGPoint(x: rect.minX, y: rect.minY+radius)
        let tlc = CGPoint(x: rect.minX + radius, y: rect.minY + radius)
        
        path.move(to: tr)
        path.addLine(to: br)
        path.addLine(to: bl)
        
        if value == "/" || value == "=" {
            path.addLine(to: tls)
            path.addRelativeArc(center: tlc, radius: radius, startAngle: Angle.degrees(90), delta: Angle.degrees(180))
        } else {
            path.addLine(to: tl)
        }
        
        return path
    }
}

#Preview {
    ContentView()
}
