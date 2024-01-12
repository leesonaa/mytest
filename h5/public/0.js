(window["webpackJsonp"] = window["webpackJsonp"] || []).push([[0],{

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./resources/js/components/common/goods-select.vue?vue&type=script&lang=js&":
/*!******************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--4-0!./node_modules/vue-loader/lib??vue-loader-options!./resources/js/components/common/goods-select.vue?vue&type=script&lang=js& ***!
  \******************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @babel/runtime/regenerator */ "./node_modules/@babel/runtime/regenerator/index.js");
/* harmony import */ var _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _scan__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./scan */ "./resources/js/components/common/scan.vue");


function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

/* harmony default export */ __webpack_exports__["default"] = ({
  name: "goods-select",
  props: {
    isOut: {
      type: Boolean,
      "default": false
    }
  },
  components: {
    Scan: _scan__WEBPACK_IMPORTED_MODULE_1__["default"]
  },
  data: function data() {
    return {
      visible: false,
      loading: false,
      finished: false,
      list: [],
      selectData: [],
      form: {
        page: 1,
        size: 10,
        keyword: ''
      },
      goodsApi: '/api/getGoodsList',
      entries: []
    };
  },
  methods: {
    show: function show(list) {
      var me = this;
      me.entries = list;
      me.formatSelectShow();
      me.visible = true;
    },
    scanData: function scanData(val) {
      var me = this;
      me.form.keyword = val;
      me.search();
    },
    query: function query() {
      var me = this;

      if (me.isOut) {
        //需要清理选中商品的price
        me.entries = me.entries.map(function (map) {
          return _objectSpread(_objectSpread({}, map), {}, {
            price: "0.00",
            amount: "0.00"
          });
        });
      }

      me.$emit('query', me.entries);
      me.entries = [];
      me.formatSelectShow();
      me.visible = false;
    },
    formatSelectShow: function formatSelectShow() {
      var me = this;

      if (me.list.length > 0) {
        var selectData = me.entries.map(function (map) {
          return map.invId;
        });
        me.list = me.list.map(function (map) {
          var checked = selectData.includes(map.id);
          me.$refs['goodsSelect-' + map.id][0].toggle(checked);
          return _objectSpread(_objectSpread({}, map), {}, {
            checked: checked
          });
        });
        me.$forceUpdate();
      }
    },
    selected: function selected(index, item) {
      var me = this;
      item.checked = !item.checked;

      if (!item.checked) {
        me.entries.splice(index, 1);
      } else {
        var itemNew = {
          "invId": item.id,
          "invNumber": item.number,
          "invName": item.name,
          "invSpec": item.spec,
          "barCode": item.barCode,
          "skuId": -1,
          "skuName": "",
          "unitId": -1,
          "mainUnit": item.unitName,
          "qty": "1.00",
          "price": item.purPrice.toFixed(2),
          "discountRate": "0",
          "deduction": "0.00",
          "amount": item.purPrice.toFixed(2),
          "locationId": item.locationId,
          "locationName": item.locationName,
          "serialno": "",
          "description": "",
          "srcOrderEntryId": "0",
          "srcOrderId": "0",
          "srcOrderNo": ""
        };

        if (me.entries.length) {
          var flag = true;
          me.entries.filter(function (self, index, arr) {
            if (self.invId == itemNew.invId) {
              flag = false;
              me.entries[index].qty = (Number(me.entries[index].qty) + 1).toFixed(2);
            }
          });

          if (flag) {
            me.entries.push(itemNew);
          }
        } else {
          me.entries.push(itemNew);
        }
      }
    },
    search: function search() {
      var me = this;
      me.loading = true;
      me.finished = false;
      me.form.page = 1;
      me.goodsList = [];
      me.onload();
    },
    cancel: function cancel() {},
    //默认加载商品信息
    onload: function onload() {
      var _this = this;

      return _asyncToGenerator( /*#__PURE__*/_babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_0___default.a.mark(function _callee() {
        var me, para, rep, _rep$data, status, data, msg, form;

        return _babel_runtime_regenerator__WEBPACK_IMPORTED_MODULE_0___default.a.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                me = _this;
                para = me.form;
                _context.next = 4;
                return axios.get(me.goodsApi, {
                  params: para
                });

              case 4:
                rep = _context.sent;
                _rep$data = rep.data, status = _rep$data.status, data = _rep$data.data, msg = _rep$data.msg;

                if (status === 'success') {
                  form = {
                    current_page: data.data.current_page,
                    total: data.total,
                    last_page: data.last_page,
                    page: data.current_page + 1
                  };
                  me.form = form;

                  if (!data.next_page_url) {
                    //数据已经读取完毕
                    me.finished = true;
                  }

                  if (me.list.length) {
                    me.list = me.list.concat(data.data);
                  } else {
                    me.list = data.data;
                  }

                  me.list = me.list.map(function (map) {
                    return _objectSpread(_objectSpread({}, map), {}, {
                      checked: false
                    });
                  });
                } else if (status === 'noLogin') {
                  me.cookie.clearCookie('token');
                  me.$router.push({
                    path: '/login'
                  }); //关闭加载

                  me.finished = true;
                  me.$toast.fail(msg);
                }

                me.loading = false;

              case 8:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }))();
    }
  },
  mounted: function mounted() {}
});

/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./resources/js/components/common/goods-select.vue?vue&type=template&id=22072b7c&scoped=true&":
/*!**********************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./resources/js/components/common/goods-select.vue?vue&type=template&id=22072b7c&scoped=true& ***!
  \**********************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c(
    "van-popup",
    {
      style: { height: "90%" },
      attrs: { position: "bottom" },
      model: {
        value: _vm.visible,
        callback: function($$v) {
          _vm.visible = $$v
        },
        expression: "visible"
      }
    },
    [
      _c(
        "div",
        { staticStyle: { overflow: "hidden", position: "relative" } },
        [
          _c(
            "van-sticky",
            [
              _c(
                "van-button",
                {
                  staticStyle: { float: "left" },
                  attrs: { type: "default", size: "normal" },
                  on: { click: _vm.cancel }
                },
                [_vm._v("取消")]
              ),
              _vm._v(" "),
              _c(
                "van-button",
                {
                  staticStyle: { float: "right" },
                  attrs: { type: "default", size: "normal" },
                  on: { click: _vm.query }
                },
                [_vm._v("确认")]
              )
            ],
            1
          )
        ],
        1
      ),
      _vm._v(" "),
      _c(
        "div",
        { staticStyle: { padding: "5% 5% 0%" } },
        [
          _c("van-search", {
            attrs: {
              "show-action": "",
              placeholder: "输入商品编号/名称/型号查询"
            },
            on: { search: _vm.search },
            scopedSlots: _vm._u([
              {
                key: "left",
                fn: function() {
                  return [
                    _c("scan", {
                      attrs: { dataObj: {} },
                      on: { scan: _vm.scanData }
                    })
                  ]
                },
                proxy: true
              },
              {
                key: "left-icon",
                fn: function() {
                  return undefined
                },
                proxy: true
              },
              {
                key: "action",
                fn: function() {
                  return [
                    _c("div", { on: { click: _vm.search } }, [_vm._v("搜索")])
                  ]
                },
                proxy: true
              }
            ]),
            model: {
              value: _vm.form.keyword,
              callback: function($$v) {
                _vm.$set(_vm.form, "keyword", $$v)
              },
              expression: "form.keyword"
            }
          }),
          _vm._v(" "),
          _c(
            "van-list",
            {
              attrs: { finished: _vm.finished, "finished-text": "没有更多了" },
              on: { load: _vm.onload },
              model: {
                value: _vm.loading,
                callback: function($$v) {
                  _vm.loading = $$v
                },
                expression: "loading"
              }
            },
            [
              _c(
                "van-checkbox-group",
                {
                  model: {
                    value: _vm.selectData,
                    callback: function($$v) {
                      _vm.selectData = $$v
                    },
                    expression: "selectData"
                  }
                },
                _vm._l(_vm.list, function(item, index) {
                  return _c("van-cell", {
                    key: item.id,
                    attrs: {
                      title:
                        item.name +
                        (item.barCode ? "(条码:" + item.barCode + ")" : "") +
                        (item.spec ? "(规格:" + item.spec + ")" : ""),
                      clickable: ""
                    },
                    on: {
                      click: function($event) {
                        $event.stopPropagation()
                        return _vm.selected(index, item)
                      }
                    },
                    scopedSlots: _vm._u(
                      [
                        {
                          key: "right-icon",
                          fn: function() {
                            return [
                              _c("van-checkbox", {
                                ref: "goodsSelect-" + item.id,
                                refInFor: true,
                                class: "checkboxes-" + item.id,
                                attrs: { name: item.id, shape: "square" },
                                model: {
                                  value: item.checked,
                                  callback: function($$v) {
                                    _vm.$set(item, "checked", $$v)
                                  },
                                  expression: "item.checked"
                                }
                              })
                            ]
                          },
                          proxy: true
                        }
                      ],
                      null,
                      true
                    )
                  })
                }),
                1
              )
            ],
            1
          )
        ],
        1
      )
    ]
  )
}
var staticRenderFns = []
render._withStripped = true



/***/ }),

/***/ "./resources/js/components/common/goods-select.vue":
/*!*********************************************************!*\
  !*** ./resources/js/components/common/goods-select.vue ***!
  \*********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _goods_select_vue_vue_type_template_id_22072b7c_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./goods-select.vue?vue&type=template&id=22072b7c&scoped=true& */ "./resources/js/components/common/goods-select.vue?vue&type=template&id=22072b7c&scoped=true&");
/* harmony import */ var _goods_select_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./goods-select.vue?vue&type=script&lang=js& */ "./resources/js/components/common/goods-select.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _goods_select_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _goods_select_vue_vue_type_template_id_22072b7c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"],
  _goods_select_vue_vue_type_template_id_22072b7c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  "22072b7c",
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "resources/js/components/common/goods-select.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./resources/js/components/common/goods-select.vue?vue&type=script&lang=js&":
/*!**********************************************************************************!*\
  !*** ./resources/js/components/common/goods-select.vue?vue&type=script&lang=js& ***!
  \**********************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_4_0_node_modules_vue_loader_lib_index_js_vue_loader_options_goods_select_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--4-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./goods-select.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./resources/js/components/common/goods-select.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_4_0_node_modules_vue_loader_lib_index_js_vue_loader_options_goods_select_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./resources/js/components/common/goods-select.vue?vue&type=template&id=22072b7c&scoped=true&":
/*!****************************************************************************************************!*\
  !*** ./resources/js/components/common/goods-select.vue?vue&type=template&id=22072b7c&scoped=true& ***!
  \****************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_goods_select_vue_vue_type_template_id_22072b7c_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./goods-select.vue?vue&type=template&id=22072b7c&scoped=true& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./resources/js/components/common/goods-select.vue?vue&type=template&id=22072b7c&scoped=true&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_goods_select_vue_vue_type_template_id_22072b7c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_goods_select_vue_vue_type_template_id_22072b7c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ })

}]);