//+------------------------------------------------------------------+
//|                                                       KYA_COPIER |
//|                                                           KYA FX |
//|                                                  https://kya.net |
//+------------------------------------------------------------------+

#include "Helpers.mqh"
#include "Enums.mqh"
#include  <Trade/Trade.mqh>

input ENUM_COPY_MODES COPY_MODE = COPY_MODE_MASTER; //Copy mode
input string input_accounts="31047607,31047612"; //Accounts allowed
string account;
string accounts[];
CTrade trader;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   account=(string)AccountInfoInteger(ACCOUNT_LOGIN);
   format_account(accounts, input_accounts, COPY_MODE);
   if(COPY_MODE==COPY_MODE_MASTER && !in_array(accounts, account))
      return(INIT_SUCCEEDED);
// Acount found and can continue the process
   EventSetMillisecondTimer(1000);
   return(INIT_SUCCEEDED);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void dump_master_trades()
  {
   string prev_pos[];
   string current_pos[];
   string data_folder = MQLInfoString(MQL_PROGRAM_NAME)+"\\"+account;

   scan_folder(prev_pos, data_folder+"\\*");

   for(int i=0; i<PositionsTotal(); i++)
     {
      CPositionInfo pos;
      pos.SelectByIndex(i);
      position_dump(pos,data_folder);
      const int size = ArraySize(current_pos);
      ArrayResize(current_pos, size+1);
      current_pos[size]=""+(string)pos.Ticket();
     }

//renove closed trades
   for(int i=0; i<ArraySize(prev_pos); i++)
     {
      if(!in_array(current_pos, prev_pos[i]))
        {
         FileDelete(data_folder+"\\"+prev_pos[i], FILE_COMMON);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void update_slave_trades(string provider)
  {
   string data_folder = MQLInfoString(MQL_PROGRAM_NAME)+"\\"+provider;
   string provider_pos[];
   scan_folder(provider_pos, data_folder+"\\*");

   for(int i=0; i<PositionsTotal(); i++)
     {
      CPositionInfo pos;
      pos.SelectByIndex(i);
      
      string copy_data[];
      StringSplit(pos.Comment(),'.', copy_data);

      if(ArraySize(copy_data)<2)
         continue;
      if(copy_data[0]!=provider)
         continue;
      //ticket de la position du provider
      string pos_ref=copy_data[1];
      //close position if no more exists
      if(!in_array(provider_pos,pos_ref))
         trader.PositionClose(pos.Ticket());
      else
        {
         Position p;
         position_load(data_folder+"\\"+pos_ref,p);
         if(pos.StopLoss()!=p.stop_loss || pos.TakeProfit()!=p.take_profit)
            trader.PositionModify(pos.Ticket(), p.stop_loss, p.take_profit);
         array_remove(provider_pos,pos_ref);
        }
     }
//Open new positions

  for(int i=0; i<ArraySize(provider_pos); i++)
     {
      Position p;
      position_load(data_folder+"\\"+provider_pos[i],p);

      string comment =provider+"."+(string)p.ticket;
      if(p.type==POSITION_TYPE_BUY)
         trader.Buy(p.volume,p.symbol,0, p.stop_loss, p.take_profit, comment);
      else
         if(p.type==POSITION_TYPE_SELL)
            trader.Sell(p.volume,p.symbol,0, p.stop_loss, p.take_profit, comment);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer(void)
  {
   if(COPY_MODE==COPY_MODE_MASTER)
     {
      dump_master_trades();
     }
   else
     {
      for(int i=0; i<ArraySize(accounts); i++)
        {
         if(account!=accounts[i])
            update_slave_trades(accounts[i]);
        }

     }
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//96666666
