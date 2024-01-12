(window.webpackJsonp=window.webpackJsonp||[]).push([[2],{104:function(t,e,o){var n=o(183);"string"==typeof n&&(n=[[t.i,n,""]]);var a={hmr:!0,transform:void 0,insertInto:void 0};o(49)(n,a);n.locals&&(t.exports=n.locals)},106:function(t,e,o){"use strict";var n=o(21),a=o.n(n),i=o(62);function s(t,e,o,n,a,i,s){try{var r=t[i](s),c=r.value}catch(t){return void o(t)}r.done?e(c):Promise.resolve(c).then(n,a)}function r(t,e){var o=Object.keys(t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(t);e&&(n=n.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),o.push.apply(o,n)}return o}function c(t){for(var e=1;e<arguments.length;e++){var o=null!=arguments[e]?arguments[e]:{};e%2?r(Object(o),!0).forEach((function(e){l(t,e,o[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(o)):r(Object(o)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(o,e))}))}return t}function l(t,e,o){return e in t?Object.defineProperty(t,e,{value:o,enumerable:!0,configurable:!0,writable:!0}):t[e]=o,t}var u={name:"goods-select",props:{isOut:{type:Boolean,default:!1}},components:{Scan:i.a},data:function(){return{visible:!1,loading:!1,finished:!1,list:[],selectData:[],form:{page:1,size:10,keyword:""},goodsApi:"/api/getGoodsList",entries:[]}},methods:{show:function(t){this.entries=t,this.formatSelectShow(),this.visible=!0},scanData:function(t){this.form.keyword=t,this.search()},query:function(){var t=this;t.isOut&&(t.entries=t.entries.map((function(t){return c(c({},t),{},{price:"0.00",amount:"0.00"})}))),t.$emit("query",t.entries),t.entries=[],t.formatSelectShow(),t.visible=!1},formatSelectShow:function(){var t=this;if(t.list.length>0){var e=t.entries.map((function(t){return t.invId}));t.list=t.list.map((function(o){var n=e.includes(o.id);return t.$refs["goodsSelect-"+o.id][0].toggle(n),c(c({},o),{},{checked:n})})),t.$forceUpdate()}},selected:function(t,e){var o=this;if(e.checked=!e.checked,e.checked){var n={invId:e.id,invNumber:e.number,invName:e.name,invSpec:e.spec,barCode:e.barCode,skuId:-1,skuName:"",unitId:-1,mainUnit:e.unitName,qty:"1.00",price:e.purPrice.toFixed(2),discountRate:"0",deduction:"0.00",amount:e.purPrice.toFixed(2),locationId:e.locationId,locationName:e.locationName,serialno:"",description:"",srcOrderEntryId:"0",srcOrderId:"0",srcOrderNo:""};if(o.entries.length){var a=!0;o.entries.filter((function(t,e,i){t.invId==n.invId&&(a=!1,o.entries[e].qty=(Number(o.entries[e].qty)+1).toFixed(2))})),a&&o.entries.push(n)}else o.entries.push(n)}else o.entries.splice(t,1)},search:function(){var t=this;t.loading=!0,t.finished=!1,t.form.page=1,t.goodsList=[],t.onload()},cancel:function(){},onload:function(){var t,e=this;return(t=a.a.mark((function t(){var o,n,i,s,r,l,u,d;return a.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return n=(o=e).form,t.next=4,axios.get(o.goodsApi,{params:n});case 4:i=t.sent,s=i.data,r=s.status,l=s.data,u=s.msg,"success"===r?(d={current_page:l.data.current_page,total:l.total,last_page:l.last_page,page:l.current_page+1},o.form=d,l.next_page_url||(o.finished=!0),o.list.length?o.list=o.list.concat(l.data):o.list=l.data,o.list=o.list.map((function(t){return c(c({},t),{},{checked:!1})}))):"noLogin"===r&&(o.cookie.clearCookie("token"),o.$router.push({path:"/login"}),o.finished=!0,o.$toast.fail(u)),o.loading=!1;case 8:case"end":return t.stop()}}),t)})),function(){var e=this,o=arguments;return new Promise((function(n,a){var i=t.apply(e,o);function r(t){s(i,n,a,r,c,"next",t)}function c(t){s(i,n,a,r,c,"throw",t)}r(void 0)}))})()}},mounted:function(){}},d=o(12),f=Object(d.a)(u,(function(){var t=this,e=t.$createElement,o=t._self._c||e;return o("van-popup",{style:{height:"90%"},attrs:{position:"bottom"},model:{value:t.visible,callback:function(e){t.visible=e},expression:"visible"}},[o("div",{staticStyle:{overflow:"hidden",position:"relative"}},[o("van-sticky",[o("van-button",{staticStyle:{float:"left"},attrs:{type:"default",size:"normal"},on:{click:t.cancel}},[t._v("取消")]),t._v(" "),o("van-button",{staticStyle:{float:"right"},attrs:{type:"default",size:"normal"},on:{click:t.query}},[t._v("确认")])],1)],1),t._v(" "),o("div",{staticStyle:{padding:"5% 5% 0%"}},[o("van-search",{attrs:{"show-action":"",placeholder:"输入商品编号/名称/型号查询"},on:{search:t.search},scopedSlots:t._u([{key:"left",fn:function(){return[o("scan",{attrs:{dataObj:{}},on:{scan:t.scanData}})]},proxy:!0},{key:"left-icon",fn:function(){},proxy:!0},{key:"action",fn:function(){return[o("div",{on:{click:t.search}},[t._v("搜索")])]},proxy:!0}]),model:{value:t.form.keyword,callback:function(e){t.$set(t.form,"keyword",e)},expression:"form.keyword"}}),t._v(" "),o("van-list",{attrs:{finished:t.finished,"finished-text":"没有更多了"},on:{load:t.onload},model:{value:t.loading,callback:function(e){t.loading=e},expression:"loading"}},[o("van-checkbox-group",{model:{value:t.selectData,callback:function(e){t.selectData=e},expression:"selectData"}},t._l(t.list,(function(e,n){return o("van-cell",{key:e.id,attrs:{title:e.name+(e.barCode?"(条码:"+e.barCode+")":"")+(e.spec?"(规格:"+e.spec+")":""),clickable:""},on:{click:function(o){return o.stopPropagation(),t.selected(n,e)}},scopedSlots:t._u([{key:"right-icon",fn:function(){return[o("van-checkbox",{ref:"goodsSelect-"+e.id,refInFor:!0,class:"checkboxes-"+e.id,attrs:{name:e.id,shape:"square"},model:{value:e.checked,callback:function(o){t.$set(e,"checked",o)},expression:"item.checked"}})]},proxy:!0}],null,!0)})})),1)],1)],1)])}),[],!1,null,"89db5768",null);e.a=f.exports},182:function(t,e,o){"use strict";var n=o(104);o.n(n).a},183:function(t,e,o){(t.exports=o(48)(!1)).push([t.i,"\n.goods-card[data-v-95789ee0] {\n    margin: 0;\n    background-color: white;\n    border:1px solid #111;\n}\n.delete-button[data-v-95789ee0] {\n    height: 100%;\n}\n.content[data-v-95789ee0] {\n    padding: 16px 16px 160px;\n}\n",""])},248:function(t,e,o){"use strict";o.r(e);var n=o(21),a=o.n(n),i=o(106);function s(t,e,o,n,a,i,s){try{var r=t[i](s),c=r.value}catch(t){return void o(t)}r.done?e(c):Promise.resolve(c).then(n,a)}var r={name:"customer-select",data:function(){return{show:!1,loading:!1,finished:!1,api:"/api/getContactList",uid:"",form:{keyword:"",page:1,size:10},list:[]}},methods:{open:function(){this.show=!0},onLoad:function(){var t,e=this;return(t=a.a.mark((function t(){var o,n,i,s,r,c,l;return a.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return n=(o=e).form,t.next=4,axios.get(o.api,{params:n});case 4:i=t.sent,s=i.data,r=s.status,c=s.data,l=s.msg,"success"===r?(o.form={current_page:c.current_page,total:c.total,last_page:c.last_page,page:c.current_page+1,keyword:o.form.keyword},c.next_page_url||(o.finished=!0),o.list.length?o.list=o.list.concat(c.data):o.list=c.data):("noLogin"===r&&(o.cookie.clearCookie("token"),o.$router.push({path:"/login"})),o.finished=!0,o.$toast.fail(l)),o.loading=!1;case 8:case"end":return t.stop()}}),t)})),function(){var e=this,o=arguments;return new Promise((function(n,a){var i=t.apply(e,o);function r(t){s(i,n,a,r,c,"next",t)}function c(t){s(i,n,a,r,c,"throw",t)}r(void 0)}))})()},selected:function(t){this.show=!1,this.$emit("select",t)},search:function(){this.finished=!1,this.form.page=1,this.list=[]}}},c=o(12),l=Object(c.a)(r,(function(){var t=this,e=t.$createElement,o=t._self._c||e;return o("van-action-sheet",{attrs:{title:"客户"},model:{value:t.show,callback:function(e){t.show=e},expression:"show"}},[o("div",{staticClass:"content"},[o("van-search",{attrs:{"show-action":"",placeholder:"输入客户编号/名称/联系人/电话查询"},on:{search:t.search},scopedSlots:t._u([{key:"action",fn:function(){return[o("div",{on:{click:t.search}},[t._v("搜索")])]},proxy:!0}]),model:{value:t.form.keyword,callback:function(e){t.$set(t.form,"keyword",e)},expression:"form.keyword"}}),t._v(" "),o("van-list",{attrs:{finished:t.finished,"finished-text":"没有更多了"},on:{load:t.onLoad},model:{value:t.loading,callback:function(e){t.loading=e},expression:"loading"}},[o("van-radio-group",{model:{value:t.uid,callback:function(e){t.uid=e},expression:"uid"}},t._l(t.list,(function(e){return o("van-cell",{key:e.id,attrs:{title:e.name,clickable:""},on:{click:function(o){return t.selected(e)}},scopedSlots:t._u([{key:"right-icon",fn:function(){return[o("van-radio",{attrs:{name:e}})]},proxy:!0}],null,!0)})})),1)],1)],1)])}),[],!1,null,"6066424c",null).exports;function u(t,e,o,n,a,i,s){try{var r=t[i](s),c=r.value}catch(t){return void o(t)}r.done?e(c):Promise.resolve(c).then(n,a)}function d(t){return function(){var e=this,o=arguments;return new Promise((function(n,a){var i=t.apply(e,o);function s(t){u(i,n,a,s,r,"next",t)}function r(t){u(i,n,a,s,r,"throw",t)}s(void 0)}))}}var f={name:"outbound",components:{GoodsSelect:i.a,CustomerSelect:l},data:function(){return{searchForm:{page:1,size:10},locationShow:!1,dateShow:!1,listLoading:!1,minDate:"",maxDate:"",submitForm:{id:0,billNo:"",buId:0,date:"",contactName:"",totalAmount:0,totalQty:0,entries:[]},submitReset:{id:0,billNo:"",buId:0,date:"",contactName:"",totalAmount:0,totalQty:0,entries:[]},validator:function(t){return/(^[1-9][0-9]{0,8}([.][0-9]{0,2})?$)|(^0?(\.[0-9]{0,2})?$)/.test(t)},loading:!1,finished:!1,list:[],boxShow:!1,calenderShow:!1,activeNames:["1"],selectList:[],goodsList:[],locationList:[],goodsInfo:{},goodsUpdateShow:!1,storageApi:"/api/storage",addApi:"/api/invOi/outAdd",editApi:"/api/invOi/outEdit",listApi:"/api/invOi/outList",infoApi:"/api/invOi/outInfo"}},methods:{contactSelect:function(t){this.submitForm.buId=t.id,this.submitForm.contactName=t.name},addBox:function(){this.getBillNo(),this.boxShow=!0},queryGoods:function(t){this.submitForm.entries=t},getBillNo:function(){var t=this;return d(a.a.mark((function e(){var o,n,i,s,r,c;return a.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return o=t,e.next=3,axios.get("/api/getListCode/QTCK",{});case 3:n=e.sent,i=n.data,s=i.status,r=i.data,c=i.msg,"success"===s?o.submitForm.billNo=r.code:"noLogin"===s?(o.cookie.clearCookie("token"),o.$router.push({path:"/login"}),o.$toast.fail(c)):o.$toast.fail("网络错误！");case 6:case"end":return e.stop()}}),e)})))()},onSearch:function(){this.searchForm.page=1,this.onLoad()},goodsInfoUpdate:function(){this.goodsInfo.amount=this.goodsInfo.price*this.goodsInfo.qty,this.goodsInfo.amount=this.goodsInfo.amount.toFixed(2)},goodsUpdateCancel:function(){this.goodsUpdateShow=!1,"string"!=typeof this.goodsInfo.qty&&(this.goodsInfo.qty=this.goodsInfo.qty+".00")},delGoods:function(t){this.submitForm.entries.splice(t,1)},customerClick:function(t){this.submitForm.buId=t.id,this.submitForm.contactName=t.name,this.buShow=!1},localUpdate:function(t){this.goodsInfo.locationId=t.id,this.goodsInfo.locationName=t.name,this.locationShow=!1},getLocation:function(){var t=this;axios.get(t.storageApi,{}).then((function(e){var o=e.data,n=o.status,a=o.data,i=o.msg;"success"===n?t.locationList=a:("noLogin"===n&&(t.cookie.clearCookie("token"),t.$router.push({path:"/login"})),t.$toast.fail(i))})).catch((function(e){t.$toast.fail("网络错误！")}))},dateQuery:function(t){var e=this;e.searchForm.start=e.formatDate(t[0]),e.searchForm.end=e.formatDate(t[1]),e.dateShow=!1},onRefresh:function(){this.searchForm.page=1,this.finished=!1,this.onLoad()},onLoad:function(){var t=this;return d(a.a.mark((function e(){var o,n,i,s,r,c;return a.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return o=t,e.next=3,axios.get(o.listApi,{params:o.searchForm});case 3:n=e.sent,i=n.data,s=i.status,r=i.data,c=i.msg,200===s?(o.list=r.rows,r.next_page_url||(o.finished=!0),o.listLoading=!1):("noLogin"===c&&(o.cookie.clearCookie("token"),o.$router.push({path:"/login"})),o.$toast.fail(c));case 6:case"end":return e.stop()}}),e)})))()},edit:function(t){var e=this;return d(a.a.mark((function o(){var n,i,s,r,c,l;return a.a.wrap((function(o){for(;;)switch(o.prev=o.next){case 0:return n=e,i={id:t.id},o.next=4,axios.get(n.infoApi,{params:i});case 4:s=o.sent,r=s.data,r.status,c=r.data,"success"===(l=r.msg)?(n.submitForm=c,n.boxShow=!0):("noLogin"===l&&(n.cookie.clearCookie("token"),n.$router.push({path:"/login"})),n.$toast.fail(l));case 7:case"end":return o.stop()}}),o)})))()},del:function(){},updateGoods:function(t){this.goodsUpdateShow=!0,this.goodsInfo=t},cancel:function(){this.submitForm=JSON.parse(JSON.stringify(this.submitReset))},formatDate:function(t){return"".concat(t.getFullYear(),"-").concat("0"+(t.getMonth()+1),"-").concat(t.getDate()<10?"0"+t.getDate():t.getDate())},calendarClick:function(t){this.calenderShow=!1,this.submitForm.date=this.formatDate(t)},onSubmit:function(){var t=this;return d(a.a.mark((function e(){var o,n,i,s,r,c,l;return a.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:if(o=t,n=JSON.parse(JSON.stringify(o.submitForm)),i=o.editApi,0===n.id&&(i=o.addApi,n.id=-1,n.description=""),n.transTypeName="其他出库",n.transTypeId=150806,0!==n.entries.length){e.next=9;break}return o.$toast.fail("请添加商品！"),e.abrupt("return");case 9:return n.totalAmount=0,n.totalQty=0,n.entries.map((function(t){n.totalQty+=parseInt(t.qty),n.totalAmount+=parseInt(t.amount)})),n.totalAmount=n.totalAmount+".00",n.totalQty=n.totalQty+".00",e.next=16,axios.post(i,n);case 16:if(s=e.sent,r=s.data,c=r.status,r.data,l=r.msg,"success"!==c){e.next=25;break}return o.submitForm=JSON.parse(JSON.stringify(o.submitReset)),e.next=22,o.getBillNo();case 22:o.$toast.success(l),e.next=27;break;case 25:"noLogin"===c&&(o.cookie.clearCookie("token"),o.$router.push({path:"/login"})),o.$toast.fail(l);case 27:case"end":return e.stop()}}),e)})))()}},mounted:function(){this.getLocation()},created:function(){var t=(new Date).getFullYear(),e=(new Date).getMonth(),o=(new Date).getDate();this.minDate=new Date(t,0,1),this.maxDate=new Date(t,e,o),this.getBillNo()}},p=(o(182),Object(c.a)(f,(function(){var t=this,e=t.$createElement,o=t._self._c||e;return o("div",[o("h5",{staticStyle:{color:"#999",padding:"3% 5% 3%",background:"#eee","font-size":"1.1rem"}},[t._v("\n        其他出库单\n        "),o("span",{staticStyle:{float:"right"}},[o("van-button",{attrs:{type:"primary",size:"small"},on:{click:t.addBox}},[t._v("新增")])],1)]),t._v(" "),o("van-field",{attrs:{label:"时间",placeholder:"请点击选择查询时间",value:t.searchForm.start?t.searchForm.start+" 至 "+t.searchForm.end:"",clickable:"",readonly:""},on:{click:function(e){t.dateShow=!0}}}),t._v(" "),o("van-search",{attrs:{"show-action":"",placeholder:"输入单据号/客户名/序列号/备注查询"},scopedSlots:t._u([{key:"action",fn:function(){return[o("van-button",{attrs:{type:"info",size:"small"},on:{click:t.onSearch}},[t._v("搜索")])]},proxy:!0}]),model:{value:t.searchForm.matchCon,callback:function(e){t.$set(t.searchForm,"matchCon",e)},expression:"searchForm.matchCon"}}),t._v(" "),o("van-calendar",{attrs:{type:"range","min-date":t.minDate,"max-date":t.maxDate},on:{confirm:t.dateQuery},model:{value:t.dateShow,callback:function(e){t.dateShow=e},expression:"dateShow"}}),t._v(" "),o("div",{staticStyle:{padding:"3%"}},[o("van-pull-refresh",{on:{refresh:t.onRefresh},model:{value:t.listLoading,callback:function(e){t.listLoading=e},expression:"listLoading"}},[o("van-list",{attrs:{finished:t.finished,"finished-text":"没有更多了"},on:{load:t.onLoad},model:{value:t.loading,callback:function(e){t.loading=e},expression:"loading"}},t._l(t.list,(function(e,n){return o("van-swipe-cell",{key:n,staticStyle:{"margin-bottom":"5%"},scopedSlots:t._u([{key:"right",fn:function(){return[o("van-button",{staticClass:"delete-button",attrs:{square:"",text:"删除",type:"danger"},on:{click:function(e){return t.del(n)}}})]},proxy:!0}],null,!0)},[o("van-card",{staticClass:"goods-card",attrs:{price:"金额："+e.totalAmount.toFixed(2),desc:"客户："+e.contactName,title:"其他出库单编号："+e.billNo},on:{click:function(o){return t.edit(e)}},scopedSlots:t._u([{key:"tags",fn:function(){return[1==e.checked?o("div",{staticStyle:{position:"absolute",top:"0",right:"0",transform:"rotate(-4deg)"}},[o("span",{staticStyle:{"font-size":"1.2rem","font-weight":"700",border:".15rem solid red",color:"#c20808",padding:".2rem .4rem","border-radius":".2rem"}},[t._v("已审核")])]):t._e()]},proxy:!0},{key:"footer",fn:function(){},proxy:!0}],null,!0)})],1)})),1)],1)],1),t._v(" "),o("van-popup",{style:{height:"90%"},attrs:{position:"bottom",closeable:""},on:{closed:t.cancel},model:{value:t.boxShow,callback:function(e){t.boxShow=e},expression:"boxShow"}},[o("div",{staticStyle:{"margin-top":"15%"}},[o("van-divider",{style:{color:"#1989fa",borderColor:"#1989fa",padding:"0 16px"}},[t._v("\n                其他出库单\n            ")]),t._v(" "),o("van-form",{attrs:{"validate-first":""}},[o("van-field",{attrs:{type:"text",label:"单据编号",readonly:""},model:{value:t.submitForm.billNo,callback:function(e){t.$set(t.submitForm,"billNo",e)},expression:"submitForm.billNo"}}),t._v(" "),o("van-field",{attrs:{readonly:"",clickable:"",label:"客户",placeholder:"请点击选择客户"},on:{click:function(e){return t.$refs.customerSelect.open()}},model:{value:t.submitForm.contactName,callback:function(e){t.$set(t.submitForm,"contactName",e)},expression:"submitForm.contactName"}}),t._v(" "),o("customer-select",{ref:"customerSelect",on:{select:t.contactSelect}}),t._v(" "),o("van-field",{attrs:{readonly:"",clickable:"",label:"日期",placeholder:"请点击日期"},on:{click:function(e){t.calenderShow=!0}},model:{value:t.submitForm.date,callback:function(e){t.$set(t.submitForm,"date",e)},expression:"submitForm.date"}}),t._v(" "),o("van-calendar",{on:{confirm:t.calendarClick},model:{value:t.calenderShow,callback:function(e){t.calenderShow=e},expression:"calenderShow"}}),t._v(" "),o("van-field",{attrs:{readonly:"",clickable:"",label:"商品列表",placeholder:"请点击选择商品"},on:{click:function(e){return t.$refs.goodsSelect.show(t.submitForm.entries)}}}),t._v(" "),o("goods-select",{ref:"goodsSelect",attrs:{isOut:!0},on:{query:t.queryGoods}}),t._v(" "),t.submitForm.entries.length?o("van-collapse",{model:{value:t.activeNames,callback:function(e){t.activeNames=e},expression:"activeNames"}},[o("van-collapse-item",{attrs:{name:"1"},scopedSlots:t._u([{key:"title",fn:function(){return[o("div",{staticStyle:{"text-align":"center",color:"rgb(25, 137, 250)"}},[t._v("商品列表（点击展开/关闭）")])]},proxy:!0}],null,!1,436080515)},[t._v(" "),t._l(t.submitForm.entries,(function(e,n){return o("van-swipe-cell",{key:n,staticStyle:{"margin-bottom":"5%"},scopedSlots:t._u([{key:"right",fn:function(){return[o("van-button",{staticClass:"delete-button",attrs:{square:"",text:"删除",type:"danger"},on:{click:function(e){return t.delGoods(n)}}})]},proxy:!0}],null,!0)},[o("van-card",{staticClass:"goods-card",attrs:{num:e.qty,price:e.price,desc:e.invSpec},on:{click:function(o){return t.updateGoods(e)}},scopedSlots:t._u([{key:"desc",fn:function(){return[o("div",{staticStyle:{display:"flex","flex-direction":"column"}},[o("span",[t._v("\n                                            商品名称："+t._s(t.submitForm.id?e.goods:e.invName)+"\n                                        ")]),t._v(" "),o("span",[t._v("\n                                            商品编号："+t._s(e.invNumber)+"\n                                        ")]),t._v(" "),o("span",[t._v("\n                                            商品条码："+t._s(e.barCode)+"\n                                        ")])])]},proxy:!0},{key:"footer",fn:function(){return[t._v("\n                                    总金额："+t._s(e.amount)+"\n                                ")]},proxy:!0}],null,!0)})],1)})),t._v(" "),o("van-popup",{style:{height:"70%"},attrs:{position:"bottom"},model:{value:t.goodsUpdateShow,callback:function(e){t.goodsUpdateShow=e},expression:"goodsUpdateShow"}},[o("div",{staticStyle:{overflow:"hidden",position:"relative"}},[o("van-button",{staticStyle:{float:"left"},attrs:{type:"default",size:"normal"},on:{click:t.goodsUpdateCancel}},[t._v("取消")]),t._v(" "),o("van-button",{staticStyle:{float:"right"},attrs:{type:"default",size:"normal"},on:{click:t.goodsUpdateCancel}},[t._v("确认")])],1),t._v(" "),o("div",{staticStyle:{background:"#eee",padding:"5% 5% 0%"}},[o("van-cell-group",[o("van-form",{attrs:{"validate-first":""}},[o("van-field",{attrs:{label:"商品",readonly:""},model:{value:t.goodsInfo.invName,callback:function(e){t.$set(t.goodsInfo,"invName",e)},expression:"goodsInfo.invName"}}),t._v(" "),o("van-field",{attrs:{label:"单位",readonly:""},model:{value:t.goodsInfo.mainUnit,callback:function(e){t.$set(t.goodsInfo,"mainUnit",e)},expression:"goodsInfo.mainUnit"}}),t._v(" "),o("van-field",{attrs:{label:"仓库",placeholder:"请点击选择仓库",readonly:"",clickable:""},on:{click:function(e){t.locationShow=!0}},model:{value:t.goodsInfo.locationName,callback:function(e){t.$set(t.goodsInfo,"locationName",e)},expression:"goodsInfo.locationName"}}),t._v(" "),o("van-field",{attrs:{label:"数量",name:"input"},scopedSlots:t._u([{key:"input",fn:function(){return[o("van-stepper",{on:{change:t.goodsInfoUpdate},model:{value:t.goodsInfo.qty,callback:function(e){t.$set(t.goodsInfo,"qty",e)},expression:"goodsInfo.qty"}})]},proxy:!0}],null,!1,754417519)}),t._v(" "),o("van-field",{attrs:{clearable:"",label:"单价",disabled:""},model:{value:t.goodsInfo.price,callback:function(e){t.$set(t.goodsInfo,"price",e)},expression:"goodsInfo.price"}}),t._v(" "),o("van-field",{attrs:{label:"出库金额",readonly:"",disabled:""},model:{value:t.goodsInfo.amount,callback:function(e){t.$set(t.goodsInfo,"amount",e)},expression:"goodsInfo.amount"}})],1)],1)],1)]),t._v(" "),o("van-action-sheet",{attrs:{actions:t.locationList,description:"选择仓库"},on:{select:t.localUpdate},model:{value:t.locationShow,callback:function(e){t.locationShow=e},expression:"locationShow"}})],2)],1):t._e(),t._v(" "),o("van-button",{attrs:{type:"info",block:""},on:{click:t.onSubmit}},[t._v("保存")])],1)],1)])],1)}),[],!1,null,"95789ee0",null));e.default=p.exports}}]);