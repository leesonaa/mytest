<template>
    <van-action-sheet v-model="show" title="客户">
        <div class="content">
            <van-search
                v-model="form.keyword"
                show-action
                placeholder="输入客户编号/名称/联系人/电话查询"
                @search="search"
            >
                <template #action>
                    <div @click="search">搜索</div>
                </template>
            </van-search>
            <van-list
                v-model="loading"
                :finished="finished"
                finished-text="没有更多了"
                @load="onLoad"
            >
                <van-radio-group v-model="uid">
                    <van-cell v-for="item in list" :key="item.id" :title="item.name" clickable @click="selected(item)">
                        <template #right-icon >
                            <van-radio :name="item" />
                        </template>
                    </van-cell>
                </van-radio-group>
            </van-list>
        </div>
    </van-action-sheet>
</template>

<script>
export default {
    name: "customer-select",
    data(){
      return {
        show: false,
        loading: false,
        finished: false,
        api:'/api/getContactList',
        uid: '',
        form: {
            keyword: '',
            page:1,
            size:10,
        },
        list: [],
      }
    },
    methods:{
        open(){
          this.show = true;
        },
        async onLoad(){
            //获取供货商列表
            const me = this;
            let para = me.form;
            let rep = await axios.get(me.api, {params:para});
            let {status,data,msg} = rep.data;
            if(status === 'success'){
                me.form = {
                    current_page: data.current_page,
                    total: data.total,
                    last_page: data.last_page,
                    page: data.current_page + 1,
                    keyword: me.form.keyword
                };
                if(!data.next_page_url){
                    //数据已经读取完毕
                    me.finished = true;
                }
                if(me.list.length){
                    me.list = me.list.concat(data.data);
                }else{
                    me.list =  data.data;
                }
            }else{
                if(status === 'noLogin'){
                    me.cookie.clearCookie('token');
                    me.$router.push({path:'/login'});
                }
                //关闭加载
                me.finished = true;
                me.$toast.fail(msg);
            }
            me.loading = false;
        },
        selected(item){
            this.show = false
            this.$emit('select',item);
        },
        search(){
            const me = this;
            me.finished = false;
            me.form.page = 1;
            me.list = [];
        },

    },
}
</script>

<style scoped>

</style>
