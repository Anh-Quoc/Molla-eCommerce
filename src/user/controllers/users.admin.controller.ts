import {Body, Controller, Get, Param, Post, Query, Req, UseGuards} from "@nestjs/common";
import {UsersService} from "../services/users.service";
import {
    ApiBearerAuth,
    ApiBody,
    ApiOperation,
    ApiParam,
    ApiProperty,
    ApiQuery,
    ApiResponse,
    ApiTags
} from "@nestjs/swagger";
import {UsersAdminService} from "../services/users.admin.service";
import {plainToClass} from "class-transformer";
import {User} from "../entities/User.entity";
import {CreateUserInputDto} from "../dtos/create-user.dto";
import {UserAdminResponseDto} from "../dtos/user.admin.response";
import {AuthGuard} from "../../auth/guards/auth.guard";

@Controller('admin')
export class UsersAdminController {
    constructor(
        private readonly usersService: UsersService,
        private readonly userAdminService: UsersAdminService
    ) {
    }

    // 7. Get list of users by permission id
    // GET /admin/users?permissionGroupId={id}

    @ApiOperation({
        summary: 'Get list of users by permission group id',
        description: 'This endpoint retrieves a list of users who are assigned to a specific permissions group.'
    })
    @ApiTags('Admin')
    @ApiQuery({
        name: 'groupId',
        description: 'The ID of the permission group to filter users by.',
        example: 1,
        required: true,
    })
    @ApiResponse({
        status: 200,
        description: 'A list of users associated with the specified permission group has been successfully retrieved.',
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. No users are associated with the specified permission group.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth()
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Get('/users')
    getUsersByPermissionGroup(@Query('groupId') id: number) {
        return this.userAdminService.findByPermissionGroupId(id);
    }


    // 8. Get user profile
    // GET /admin/users?id={id}
    @ApiOperation({
        summary: 'Get user profile by ID',
        description: 'This endpoint retrieves the profile information of a specific user identified by their ID. '
    })
    @ApiTags('Admin')
    @ApiParam({
        name: 'id',
        description: 'The unique identifier of the user whose profile is to be retrieved.',
        example: 123
    })
    @ApiResponse({
        status: 200,
        description: 'The user profile has been successfully retrieved.',
        type: User,
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The user with the specified ID does not exist.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth()
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Get('/users/:id')
    async getUserById(@Param('id') id: number): Promise<UserAdminResponseDto> {
        return plainToClass(UserAdminResponseDto, await this.userAdminService.findById(id));
    }

    @ApiOperation({
        summary: 'Create a new user',
        description: 'This endpoint allows for the creation of a new user. You need to provide the user details, including role and profile information, in the request body. ' +
            'The API creates the new user and returns the details of the created user.'
    })
    @ApiTags('Admin')
    @ApiBody({
        description: 'The data required to create a new user, including role and profile information.',
        type: CreateUserInputDto,
    })
    @ApiResponse({
        status: 201,
        description: 'The new user has been successfully created.',
        type: User,
        example: {
            "email": "john.doe@example.com",
            "password": "$2b$10$ot1CGTQEwet2oG/mecqEyuJQhKPS/B0AiHTWgqWibKwYsC/fic28a",
            "permissionGroupId": 3,
            "fullName": "John Doe",
            "address": "123 Main St, Apt 4B, Springfield, IL 62704",
            "phoneNumber": "1234567890",
            "dateOfBirth": "1980-01-01",
            "lastLogin": null, "id": 4,
            "created_at": "2024-08-15T00:14:11.926Z",
            "updated_at": "2024-08-15T00:14:11.926Z",
            "isActive": true
        }
    })
    @ApiResponse({
        status: 400,
        description: 'Bad Request. The input data is invalid or missing required fields.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth()
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Post('/users')
    createNewUser(@Body() createUserInputDto: CreateUserInputDto) {
        return this.userAdminService.createNewUser(createUserInputDto);
    }
}