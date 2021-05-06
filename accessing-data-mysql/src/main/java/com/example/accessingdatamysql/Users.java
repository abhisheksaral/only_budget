package com.example.accessingdatamysql;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class Users {
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private long id;
	private String user_name;
	private double income;
	private String picture;
	

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getuser_name() {
		return user_name;
	}

	public void setuser_name(String name) {
		this.user_name = name;
	}

	public double getIncome() {
		return income;
	}

	public void setIncome(double income) {
		this.income = income;
	}

	public String getPicture() {
		return picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
	}



}
