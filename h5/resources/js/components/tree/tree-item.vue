<template>
    <li>
        <van-radio-group>
            <span @click="toggle(data)" style="display:flex;width:100%;" :style="{background: tree.radio == data.id ? '#ccc' : '#fff'}"  @dblclick="selected(data)">
                <em style="display:flex;" v-if="hasChild" class="icon">
                    <span style="padding:0 5px;">{{open ? '-' : '+'}}</span>
                    <van-radio v-if="tree.radio == data.id" style="display:inline-block" />
                </em>
                <em v-if="!hasChild" class="icon file-text">
                    <van-radio v-if="tree.radio == data.id" style="display:inline-block" />
                </em>
                <span>{{ data.name }}</span>
            </span>
        </van-radio-group>
        <ul v-show="open" v-if="hasChild">
            <tree-item v-for="(item, index) in data.children" :data="item" :key="index"></tree-item>
        </ul>
    </li>
</template>

<script>
    export default {
        name: 'TreeItem',
        props: {
            data: {
                type: [Object, Array],
                required: true
            }
        },
        data() {
            return {
                open: false,
                tree:null,
                tt:0,
            }
        },
        computed: {
            hasChild() {
                return this.data.children && (JSON.stringify(this.data.children) != '{}')
            }
        },
        methods: {
            //点击操作
            toggle(obj) {
                var me = this;
                if(me.hasChild) {
                    me.open = !me.open
                }
                me.tree.radio = obj.id;
                me.tree.$emit('test',{name:obj.name,id:obj.id});
            },
        },
        created() {
            var me = this;
            let parent = me.$parent;
            while (parent && !parent.isTreeRoot) {
                parent = parent.$parent
            }
            me.tree = parent;
        }
    }
</script>

<style>
    ul {
        list-style: none;
        margin: 10px 0;
    }
    li {
        padding: 2% 5%;
    }
    li > span {
        cursor: pointer;
        font-size: 14px;
        line-height: 20px;
    }
    li > span:visited{
        background: #fff;
    }
    em.icon {
        display: inline-block;
        /*width: 20px;*/
        height: 20px;
        margin-right: 5px;
        background-repeat: no-repeat;
        vertical-align: middle;
    }
    .tree-menu li {
        line-height: 1.5;
    }
</style>
