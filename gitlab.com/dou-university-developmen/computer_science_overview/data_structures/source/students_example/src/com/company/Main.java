package com.company;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Main {

    public static void main(String[] args) {
        //lists();
        sets();
        //maps();
    }

    static void lists(){
        List<String> names = new ArrayList<>();

        //add
        names.add("doe");
        names.add("doe");
        names.add("john");
        names.add("john");

        print("list size: " + names.size());
        print("list contains john name: " + names.contains("john"));
        print("index of john name: " + names.indexOf("john"));

        //remove
        names.remove(3);
        names.remove("john");

        print("list size: " + names.size());
        print("list contains doe name: " + names.contains("doe"));
        print("index of john name: " + names.indexOf("john"));

        //iterate ex 1
        for(String name : names){
            print(name);
        }

        //iterate ex 2
        names.stream().forEach(System.out::println);

        //iterate ex 3
        names.stream().forEach(n -> { print(n); });

        //iterate ex 4
        boolean found = false;
        names.stream().forEach(n -> {
            if(n.equals("john")){
                //found = true;
            }
        });

        //iterate ex 5
        for(String name : names){
            if(name.equals("doe")){
                found = true;
            }
        }
        print("" + found);
    }

    static void sets(){
        Set<String> names = new HashSet<>();

        //add
        names.add("doe");
        names.add("doe");
        names.add("john");
        names.add("john");

        print("set size: " + names.size());
        print("set contains john name: " + names.contains("john"));
        //there is no indexOf method in set

        //remove
        names.remove(0);
        names.remove("john");

        print("set size: " + names.size());
        print("set contains doe name: " + names.contains("doe"));
    }

    static void maps(){
        Map<String, String> map = new HashMap<>();

        //add
        map.put("john", "john");
        map.put("doe", "doe");
        map.put("smith", "doe");

        print("map size: " + map.size());
        //print("map contains john: " + map.contains("john"));
        print("map contains john as key: " + map.keySet().contains("john"));
        print("map contains john as value: " + map.entrySet().contains("john"));

        //remove
        map.remove("doe");
        map.remove("smith", "john");

        print("map size: " + map.size());

        //iterate ex 1
        for(String key : map.keySet()){
            print(map.get(key));
        }
    }

    private static void print(int text) {
        System.out.println(text);
    }

    private static void print(String text) {
        System.out.println(text);
    }
}