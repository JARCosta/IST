package ggc.core;

import java.io.Serializable;

import ggc.core.exception.InvalidDateException;

public class Date implements Serializable{
  private int _days;

  public Date(int days){
    _days = days;
  }

  public void advanceDate(int days) throws InvalidDateException{
    if(days < 1){
      throw new InvalidDateException(days);
    }
    _days += days;
  }

  public int getDate(){
    return _days;
  }

  public int difference(Date other){
    return other.getDate() - _days;
  }
  @Override
  public String toString(){
    return "" + getDate();
  }
}
