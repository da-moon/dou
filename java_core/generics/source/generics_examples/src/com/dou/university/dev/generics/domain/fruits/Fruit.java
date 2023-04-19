package com.dou.university.dev.generics.domain.fruits;

import com.dou.university.dev.generics.domain.Food;

public abstract class Fruit implements Food {

	private String color;
	private Integer tamanio;

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public Integer getTamanio() {
		return tamanio;
	}

	public void setTamanio(Integer tamanio) {
		this.tamanio = tamanio;
	}

}
