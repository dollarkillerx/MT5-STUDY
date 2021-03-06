//+------------------------------------------------------------------+
//|                                                         马丁.mq5 |
//|                                                     DollarKiller |
//|                                 https://github.com/dollarkillerx |
//+------------------------------------------------------------------+
#property copyright "DollarKiller"
#property link      "https://github.com/dollarkillerx"
#property version   "0.01 Bate"
#property description "测试中的马丁 请勿用于生成环境"
input string username; // EA平台账户
input string password; // EA平台密码
input int Majic = 666; // Majic
input int Deviation = 100; // 点差小点
input int bandsCycle = 53; // 布林带周期
input int bandsDeviation = 3; // 布林带偏差
input double initialRrderQuantity = 0.045; // 初始下单量
input int initialTakeProfit = 103; // 初始止盈点数
input int pointsAddingPositions = 219; // 加仓间隔点数
input int marginMultiple = 18; // 加仓倍数
input int maximumNumberSameDirection = 23; // 同向最大持仓数
input double totalProfit = 100; // 总获利出场
// 引入基础依赖库
#include <transaction.mqh>
#include <kdata.mqh>
#include <img.mqh>
#include <user.mqh>
Transction ts;
Kdata kdata;
Img img;
System sym;
Lib lib;
string EaName = "Supper Md 0.01 Bate";
bool Run = false;
datetime buyTime = 0;
datetime sellTime = 0;
MqlRates rate[];
/**
   这个版本交易思路非常简单 
   开单策略: 就是 布林带 下轨 开空   布林带上轨开多
   趋势判断:
   加仓策略:
   止损策略:
   止盈策略:
   出场策略:
*/


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(259200); // 每3天检测下 ea账户是否过期
   initEa();
   kdata.getRates(4,rate);
   buyTime = rate[1].time;
   sellTime = rate[1].time;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   kdata.getRates(4,rate);
   double bandsUp[],bandsLow[],bandsMid[];
   kdata.Bands(bandsMid,bandsUp,bandsLow,4,Symbol(),0,bandsCycle,0,bandsDeviation,PRICE_CLOSE);
   // 判断加仓 还是  开仓
   
   
   // 多单判断
   int buyTotals = ts.positionGetTotal(Symbol(),POSITION_TYPE_BUY,Majic);
   if (buyTotals == 0) {
      // 开单
      if (rate[1].open > bandsLow[1] && rate[1].close > bandsLow[1] && rate[2].low < bandsLow[2] && buyTime != rate[0].time) {
         if (ts.buyPlus(Symbol(),ts.formatLots(Symbol(),initialRrderQuantity),0,totalProfit,Symbol() + ":buy",Majic,Deviation) > 0) {
            buyTime = rate[0].time;
         }    
      }
   }else {
      // 获取最近的订单判断是否符合加仓条件
      transctionOrderData td;
      ts.positionGetRecent(Symbol(),POSITION_TYPE_BUY,Majic,td);
      ts.modfiySlTp(Symbol(),POSITION_TYPE_BUY,-1,td.openTp);
      if( buyTotals <= maximumNumberSameDirection && (td.openPrice - kdata.getAsk(Symbol())) >= pointsAddingPositions * Point() ) {
         if (ts.buyPlus(Symbol(),ts.formatLots(Symbol(),td.openLots * marginMultiple),0,totalProfit,Symbol() + ":buy:" + IntegerToString(buyTotals),Majic,Deviation) < 0) {
            Alert("Buy加仓失败");
         }
      }
   }
   
   // 空单判断
//   int sellTotals = ts.positionGetTotal(Symbol(),POSITION_TYPE_SELL,Majic);
//   if (sellTotals == 0) {
//      if (rate[1].open < bandsUp[1] && rate[1].close < bandsUp[1] && rate[2].high > bandsUp[1] && sellTime != rate[0].time) {
//         if (ts.sellPlus(Symbol(),ts.formatLots(Symbol(),initialRrderQuantity),0,totalProfit,Symbol() + ":sell",Majic,Deviation) > 0) {
//            sellTime = rate[0].time;
//         }
//      }
//   }else {
//      // 加仓逻辑
//      transctionOrderData td;
//      ts.positionGetRecent(Symbol(),POSITION_TYPE_SELL,Majic,td);
//      ts.modfiySlTp(Symbol(),POSITION_TYPE_SELL,-1,td.openTp);
//      if( sellTotals <= maximumNumberSameDirection && (kdata.getBid(Symbol()) - td.openPrice) >= pointsAddingPositions * Point() ) {
//         if (ts.sellPlus(Symbol(),ts.formatLots(Symbol(),td.openLots * marginMultiple),0,totalProfit,Symbol() + ":sell:" + IntegerToString(sellTotals),Majic,Deviation) < 0) {
//            Alert("Sell加仓失败");
//         }
//      }
//   }
//   
   
   //transctionOrderData td;
   //ts.positionGetRecent(Symbol(),POSITION_TYPE_BUY,Majic,td);
   //printf("当前价格: %f",td.price);
   //printf("开仓价格: %f",td.openPrice);
   //printf("当前利润: %f",td.profit);
   //printf("");
   
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   // 这里填写检测函数 需要编译C++时间需要久 现在就先搁置
   // 验证服务器请配备SSL防止中间人攻击 验证服务器伪造
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
  if(id==CHARTEVENT_OBJECT_CLICK) {
      if (sparam == "run") {
         // 按钮弹起
         ObjectSetInteger(0,"run",OBJPROP_STATE,false);
         if (Run == false) {
            Run = true;
            ObjectSetString(0,"run",OBJPROP_TEXT,"关闭EA");
            ObjectSetString(0,"runLable",OBJPROP_TEXT,"EA正在运行");
         }else {
            Run = false;
            ObjectSetString(0,"run",OBJPROP_TEXT,"启动EA");
            ObjectSetString(0,"runLable",OBJPROP_TEXT,"EA没有运行");
         }
      }else if (sparam == "closeAll") {
         ObjectSetInteger(0,"closeAll",OBJPROP_STATE,false);
         if (ts.closeAllBySymbol(Symbol(),Deviation,Majic) == false) {
            Alert("平仓失败!!!");
         }
      }
   }
  }
//+------------------------------------------------------------------+
void initEa() {
   printf("初始化 " + EaName + "  " + lib.getServerTimeString() + "   " + sym.serverName());
   if (sym.settingAllowsTransactions() == false) {
      Alert("当前设置不允许EA允许 请检测设置!!!");
   }
   
   img.lable("title",EaName,500,50,0,255,30);
   img.button("run","启动EA",1000,50,80,50,0,clrDarkGreen,10);
   img.lable("runLable","EA没有运行",1400,50,0,255,15);
   img.button("closeAll","平仓所有订单",1450,50,120,50,1,clrDarkGreen,10);
}