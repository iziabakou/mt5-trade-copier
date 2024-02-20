//+------------------------------------------------------------------+
//|                                                       KYA_COPIER |
//|                                                           KYA FX |
//|                                                  https://kya.net |
//+------------------------------------------------------------------+
#include "Enums.mqh"
#include  <Trade/Trade.mqh>
//+------------------------------------------------------------------+
//|                                                       KYA_COPIER |
//|                                                           KYA FX |
//|                                                  https://kya.net |
//+------------------------------------------------------------------+
struct Position
  {
   string            symbol;
   ENUM_POSITION_TYPE type;
   ulong              ticket;
   datetime          time;
   datetime          time_update;
   double            volume;
   double            price_open;
   double            stop_loss;
   double            take_profit;
   string            comment;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PosToStruct(const CPositionInfo& pinfo, Position& pos)
  {
   pos.symbol=pinfo.Symbol();
   pos.type=pinfo.PositionType();
   pos.ticket=pinfo.Ticket();
   pos.time=pinfo.Time();
   pos.time_update=pinfo.TimeUpdate();
   pos.volume=pinfo.Volume();
   pos.price_open=pinfo.PriceOpen();
   pos.stop_loss=pinfo.StopLoss();
   pos.take_profit=pinfo.TakeProfit();
   pos.comment=pinfo.Comment();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string position_dump(const CPositionInfo &pinfo, string folder)
  {

   string fullpath= folder+"\\"+(string)pinfo.Ticket();
   int file=FileOpen(fullpath, FILE_COMMON|FILE_BIN|FILE_WRITE);
   if(file==INVALID_HANDLE)
      return NULL;
   const string symbol = pinfo.Symbol();
   const int len= StringLen(symbol);
   FileWriteInteger(file, len);
   FileWriteString(file, symbol);
   FileWriteInteger(file, pinfo.PositionType());
   FileWriteLong(file, pinfo.Ticket());
   FileWriteDouble(file,pinfo.Volume());
   FileWriteDouble(file,pinfo.PriceOpen());
   FileWriteDouble(file,pinfo.StopLoss());
   FileWriteDouble(file,pinfo.TakeProfit());
   FileWriteLong(file,pinfo.Time());
   FileWriteLong(file,pinfo.TimeUpdate());
   FileClose(file);
   return fullpath;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void position_load(string path, Position &p)
  {
   int file= FileOpen(path, FILE_BIN|FILE_COMMON|FILE_READ);
   if(file==INVALID_HANDLE)
      return;
   p.symbol=FileReadString(file, FileReadInteger(file));
   p.type=(ENUM_POSITION_TYPE)FileReadInteger(file);
   p.ticket = FileReadLong(file);
   p.volume=FileReadDouble(file);
   p.price_open=FileReadDouble(file);
   p.stop_loss=FileReadDouble(file);
   p.take_profit=FileReadDouble(file);
   p.time = FileReadLong(file);
   p.time_update = FileReadLong(file);
   FileClose(file);
  }

template<typename T>
int index_of(const T& array[], const T& value)
  {
// Loop through the array
   for(int i = 0; i < ArraySize(array); i++)
     {
      // Check if the value is equal to the current element
      if(array[i] == value)
         return i; // Value is found in the array
     }
   return -1; // Value is not found in the array
  }

template<typename T>
int in_array(const T& array[], const T& value)
  {
   return index_of(array, value)>=0;
  }

template<typename T>
string array_join(const T& array[], const string delimiter=",")
  {
   string result = "";
   for(int i = 0; i < ArraySize(array); i++)
     {
      if(i > 0)
         result += delimiter;
      result += array[i];
     }

   return result;
  }

template<typename T>
void array_print(const T& array[])
  {
   Print("["+array_join(array)+"]");
  }


template<typename T>
void array_remove(T& array[], const T value)
  {
   if(in_array(array, value))
      ArrayRemove(array,index_of(array, value),1) ;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void format_account(string &output[], string input_account, ENUM_COPY_MODES M)
  {
   string temp[]= {};

   StringReplace(input_account, " ", "");
   StringReplace(input_account, ";", ",");
   while(StringFind(input_account,",,")>=0)
     {
      StringReplace(input_account, ",,", ",");
     }
   if(StringLen(input_account))
     {
      StringSplit(input_account, ',', temp);

     }
   else
      if(M==COPY_MODE_MASTER)
        {
         string _temp[]= {(string)AccountInfoInteger(ACCOUNT_LOGIN)} ;
         ArrayCopy(temp,_temp);
        }

   ArrayResize(output, ArraySize(temp));
   ArrayCopy(output, temp);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void scan_folder(string &output[], string path, int flag=FILE_COMMON)
  {
   string filename;
   const long scanner = FileFindFirst(path, filename, flag);
   if(scanner==INVALID_HANDLE)
      return;
   ArrayResize(output, ArraySize(output)+1);
   output[0]=filename;

   while(FileFindNext(scanner, filename))
     {
      const int size= ArraySize(output);
      ArrayResize(output,size+1);
      output[size]=filename;
     }
   FileFindClose(scanner);
  }


//+------------------------------------------------------------------+
