const tool = {}

tool.getParams = (name)=>{
    let search = window.location.search.substr(1) || window.location.hash.split("?")[1];
    if(!search){
        return null;
    }
    let reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    let r = search.match(reg);
    if (r != null) return  unescape(r[2]); return null;
};

export default tool
