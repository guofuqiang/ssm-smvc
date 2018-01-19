package com.mybatis.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mybatis.demo.dao.UserMapper;
import com.mybatis.demo.entity.User;

@Service
public class UserService {

	@Autowired
	private UserMapper userMapper;
	
	public List<User> getUsers(Map map){
		return userMapper.getUsers( map);
	}
	
	public Long getTotalUser(){
		return userMapper.getTotalUser();
	}
	
	public int updateUser(User user){
		return userMapper.updateUser(user);
	}
	
	public int addUser(User user){
		return userMapper.addUser(user);
	}
	
	public int deleteUser(Integer id){
		return userMapper.deleteUser(id);
	}
}
