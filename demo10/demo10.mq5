//+------------------------------------------------------------------+
//|                                                       demo10.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs  // 显示输入框
// input double lots = 0.1; 接受用户输入
#include <transaction.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Transction tc;
   //ulong id = tc.buy(Symbol(),0.1,20,20,"this is buy demo test",666,10);
   //if (id == 0) {
   //  printf("下单失败");
   //}else {
   //   printf("下单成功 订单号: %d",id);
   //}

   
   //id = tc.sell(Symbol(),0.1,20,20,"this is sell demo test",666,10);
   //if (id == 0) {
   //   printf("下单失败");
   //}else {
   //   printf("下单成功 订单编号: %d",id);
   //}
   
   
//   if (tc.closeAllBuyBySymbol(Symbol(),50)) {
//      printf("自动平仓Buy成功");
//   }else {
//      printf("自动平仓Buy失败");
//   }
//   
//   if (tc.closeAllSellBySymbol(Symbol(),50)) {
//      printf("自动平仓Sell成功");
//   }else {
//      printf("自动平仓Sell失败");
//   }

   //if(tc.closeAllBySymbol(Symbol(),10)) {
   //   printf("自动平仓成功");
   //}else {
   //   printf("自动平仓失败");
   //}
   
   // 删除所有挂单
   tc.delPending(Symbol());
  }
//+------------------------------------------------------------------+

void show() {
   Alert("Hello World");
}