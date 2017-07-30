#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

public class AnimationHelper : EditorWindow {
    public GameObject target;
    public AnimationClip idleAnim;
    public AnimationClip walkAnim;
    public AnimationClip runAnim;

    [MenuItem ("Window/Animation Helper")]
    static void OpenWindow ()
    {
        GetWindow<AnimationHelper>();
    }

    void OnGui()
    {
        target = EditorGUILayout.ObjectField("Target Object", target, typeof(GameObject), true) as GameObject;
        idleAnim = EditorGUILayout.ObjectField("idle", idleAnim, typeof(AnimationClip), false) as AnimationClip;
        walkAnim = EditorGUILayout.ObjectField("walk", walkAnim, typeof(AnimationClip), false) as AnimationClip;
        runAnim = EditorGUILayout.ObjectField("run", runAnim, typeof(AnimationClip), false) as AnimationClip;

        if (GUILayout.Button("Create"))
        {
            if (target == null) {
                Debug.LogError("No target for animator controller set.");
                return;
            }

            Create();
        }
    }

    void Create() {
        AnimatorController controller = AnimatorController.CreateAnimatorControllerAtPath("Assets/" + target.name + ".controller");

        controller.AddParameter("Speed", AnimatorControllerParameterType.Float);

        AnimatorState idleState = controller.layers[0].stateMachine.AddState("Idle");
        idleState.motion = idleAnim;

        BlendTree blendTree;
        AnimatorState moveState = controller.CreateBlendTreeInController("Move", out blendTree);

        blendTree.blendType = BlendTreeType.Simple1D;
        blendTree.blendParameter = "Speed";
        blendTree.AddChild(walkAnim);
        blendTree.AddChild(runAnim);

        AnimatorStateTransition leaveIdle = idleState.AddExitTransition(moveState);
        AnimatorStateTransition leaveMove = idleState.AddExitTransition(idleState);

        leaveIdle.AddCondition(AnimatorConditionMode.Greater, 0.01f, "Speed");
        leaveMove.AddCondition(AnimatorConditionMode.Less, 0.01f, "Speed");

        target.GetComponent<Animator>().runtimeAnimatorController = controller;
    }
}

#endif