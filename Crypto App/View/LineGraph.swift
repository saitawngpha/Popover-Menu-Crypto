//
//  LineGraph.swift
//  Analytics Line
//
//  Created by Steve Pha on 1/30/23.
//

import SwiftUI


//MARK: We don't need gesture for this app

struct LineGraph: View {
    //Number of plots
    var data: [Double]
    @State var currentPlot = ""
    //Animation Graph
    @State var graphProgress: CGFloat = 0
    var profit = false
    var body: some View {
        GeometryReader{ proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            //converting plots as points
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            let points = data.enumerated().compactMap { item -> CGPoint in
                //getting progress and multiplying with height
                // Making to show with minimum amount
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height)
                
                //width
                let pathWidth = width * CGFloat(item.offset)
                
                //since we need peak to top not bottom
                return CGPoint(x: pathWidth, y: -pathHeight + height)
                
            }
            
            ZStack{
                
                //Path
                AnimationGraphPath(progress: graphProgress, points: points)
                                .fill(
                    
                    //Gradient
                    LinearGradient(colors: [
                        profit ? Color("Profit") : Color("Loss"),
                        profit ? Color("Profit") : Color("Loss")
                    ], startPoint: .leading, endPoint: .trailing)
                
                )
                
                //Path background color
                FillBG()
                
                //Clip the shape
                .clipShape(
                    
                    Path{ path in
                        //drawing the points
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                    
                )
                //.padding(.top, 15)
                .opacity(graphProgress)
            }//end zstack
            
            
        }
        .padding(.horizontal, 10)
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 1.2)){
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data){ newValue in
            graphProgress = 0
            //MARK: Reanimating when ever Plot data updates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 1.2)){
                    graphProgress = 1
                }
            }
        }
        
    }
    
    @ViewBuilder
    func FillBG() -> some View{
        //Path background color
        let color = profit ? Color("Profit") : Color("Loss")
        LinearGradient(colors: [
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.1),
        ]
        + Array(repeating: color.opacity(0.1), count: 4)
        + Array(repeating: Color.clear, count: 2)
        , startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}

//MARK: Animation Path
struct AnimationGraphPath: Shape {
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat {
        get{return progress}
        set{progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        //path
        Path{ path in
            //drawing the points
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))

    }
}
