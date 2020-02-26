//+------------------------------------------------------------------+
//|                                                       class2.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
// #include <newClass/class1.mqh>
#include "class1.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Humanity : public Animal
  {
public:
   string            name;
                     Humanity(string name,string race,int age)
     {
      this.name = name;
      this.race = race;
      this.age = age;
     }
   void              work()
     {
      printf(this.name + " work ...");
     }
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
