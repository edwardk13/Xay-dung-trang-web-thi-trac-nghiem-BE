<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    // Lấy tất cả user
    public function index()
    {
        return response()->json(User::all());
    }

    // Lấy user theo id
    public function show($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                "message" => "User not found"
            ], 404);
        }

        return response()->json($user);
    }

    // Tạo user
    public function store(Request $request)
    {
        $user = User::create($request->all());

        return response()->json($user, 201);
    }

    // Cập nhật user
    public function update(Request $request, $id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                "message" => "User not found"
            ], 404);
        }

        $user->update($request->all());

        return response()->json($user);
    }

    // Xóa user
    public function destroy($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                "message" => "User not found"
            ], 404);
        }

        $user->delete();

        return response()->json([
            "message" => "User deleted"
        ]);
    }
}