package com.fit.controller;

import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping
public class ChatMessageController {

	@GetMapping("/chatMessage")
	public String chatMessage(Model model, HttpSession session) {
        // 세션에 저장된 사용자 목록을 얻어옵니다. 이것은 세션 관리 방식에 따라 다를 수 있습니다.
        // 여기에서는 가상의 방식으로 사용자 목록을 얻어오는 것으로 가정합니다.
        List<String> connectedUsers = getConnectedUsersFromSession(session);

        // 현재 세션에 접속한 사용자 수를 모델에 추가합니다.
        model.addAttribute("connectedUsers", connectedUsers.size());

        // 다른 모델 속성들을 추가할 수 있습니다.

		return "/chatMessage";
	}
    // 세션으로부터 사용자 목록을 얻어오는 메서드입니다.
    private List<String> getConnectedUsersFromSession(HttpSession session) {
        // 세션에서 사용자 목록을 얻어오는 로직을 구현하세요.
        // 예를 들어, 세션 속성에 사용자 목록을 저장하고 여기서 그 목록을 반환하는 형태일 수 있습니다.
        // 실제로는 세션 관리 방법에 따라 다를 것입니다.
        // 이 예제에서는 가상의 방식으로 List<String>을 반환합니다.
        List<String> connectedUsers = new ArrayList<>();
        connectedUsers.add("User1");
        connectedUsers.add("User2");
        // ...

        return connectedUsers;
    }
}
