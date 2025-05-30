namespace SDL3_ttf;

using SDL3Native;
using System;

/**
 * A font atlas draw command.
 *
 * \since This enum is available since SDL_ttf 3.0.0.
 */
enum TTF_DrawCommand : int32
{
	TTF_DRAW_COMMAND_NOOP,
	TTF_DRAW_COMMAND_FILL,
	TTF_DRAW_COMMAND_COPY
}

/**
 * A filled rectangle draw operation.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DrawOperation
 */
[CRepr] struct TTF_FillOperation
{
	public TTF_DrawCommand cmd; /**< TTF_DRAW_COMMAND_FILL */
	public SDL_Rect rect; /**< The rectangle to fill, in pixels. The x coordinate is relative to the left side of the text area, going right, and the y coordinate is relative to the top side of the text area, going down. */
}

/**
 * A texture copy draw operation.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DrawOperation
 */
[CRepr] struct TTF_CopyOperation
{
	public TTF_DrawCommand cmd; /**< TTF_DRAW_COMMAND_COPY */
	public int32 text_offset; /**< The offset in the text corresponding to this glyph.
									  There may be multiple glyphs with the same text offset
									  and the next text offset might be several Unicode codepoints
									  later. In this case the glyphs and codepoints are grouped
									  together and the group bounding box is the union of the dst
									  rectangles for the corresponding glyphs. */
	public TTF_Font* glyph_font; /**< The font containing the glyph to be drawn, can be passed to TTF_GetGlyphImageForIndex() */
	public uint32 glyph_index; /**< The glyph index of the glyph to be drawn, can be passed to TTF_GetGlyphImageForIndex() */
	public SDL_Rect src; /**< The area within the glyph to be drawn */
	public SDL_Rect dst; /**< The drawing coordinates of the glyph, in pixels. The x coordinate is relative to the left side of the text area, going right, and the y coordinate is relative to the top side of the text area, going down. */
	public void* reserved;
}

/**
 * A text engine draw operation.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 */
[Union, CRepr] struct TTF_DrawOperation
{
	public TTF_DrawCommand cmd;
	public TTF_FillOperation fill;
	public TTF_CopyOperation copy;
}


/* Private data in TTF_Text, to assist in text measurement and layout */
[CRepr] struct TTF_TextLayout;


/* Private data in TTF_Text, available to implementations */
[CRepr] struct TTF_TextData
{
	public TTF_Font* font; /**< The font used by this text, read-only. */
	public SDL_FColor color; /**< The color of the text, read-only. */

	public bool needs_layout_update; /**< True if the layout needs to be updated */
	public TTF_TextLayout* layout; /**< Cached layout information, read-only. */
	public int32 x; /**< The x offset of the upper left corner of this text, in pixels, read-only. */
	public int32 y; /**< The y offset of the upper left corner of this text, in pixels, read-only. */
	public int32 w; /**< The width of this text, in pixels, read-only. */
	public int32 h; /**< The height of this text, in pixels, read-only. */
	public int32 num_ops; /**< The number of drawing operations to render this text, read-only. */
	public TTF_DrawOperation* ops; /**< The drawing operations used to render this text, read-only. */
	public int32 num_clusters; /**< The number of substrings representing clusters of glyphs in the string, read-only */
	public TTF_SubString* clusters; /**< Substrings representing clusters of glyphs in the string, read-only */

	public SDL_PropertiesID props; /**< Custom properties associated with this text, read-only. This field is created as-needed using TTF_GetTextProperties() and the properties may be then set and read normally */

	public bool needs_engine_update; /**< True if the engine text needs to be updated */
	public TTF_TextEngine* engine; /**< The engine used to render this text, read-only. */
	public void* engine_text; /**< The implementation-specific representation of this text */
}

/**
 * A text engine interface.
 *
 * This structure should be initialized using SDL_INIT_INTERFACE()
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa SDL_INIT_INTERFACE
 */
[CRepr] struct TTF_TextEngine
{
	public uint32 version; /**< The version of this interface */

	public void* userdata; /**< User data pointer passed to callbacks */

	/* Create a text representation from draw instructions.
	 *
	 * All fields of `text` except `internal->engine_text` will already be filled out.
	 *
	 * This function should set the `internal->engine_text` field to a non-NULL value.
	 *
	 * \param userdata the userdata pointer in this interface.
	 * \param text the text object being created.
	 */
	public function bool(void* userdata, TTF_Text* text) CreateText;

	/**
	 * Destroy a text representation.
	 */
	public function void(void* userdata, TTF_Text* text) DestroyText;

}

static
{
	private static void Asserts_TTF_TextEngine_SIZE()
	{
		Compiler.Assert((sizeof(void*) == 4 && sizeof(TTF_TextEngine) == 16) || (sizeof(void*) == 8 && sizeof(TTF_TextEngine) == 32));
	}
}