//+------------------------------------------------------------------+
//|                                                       class2.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Animal
  {
public:
   string            race;
   int               age;
    Animal() {}
                     Animal(string race,int age)
     {
      this.race = race;
      this.age = age;
     }
   void              eat()
     {
      printf("eat... race:%s  age:%d",this.race,this.age);
     }
  };
//+------------------------------------------------------------------+
