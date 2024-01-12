import request from "./request"

const api = {}
api.login = function(data){
    return request.post("/api/userLogin",data);
}

export default api
